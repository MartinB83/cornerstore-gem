module Cornerstore
  module Model
    class Base
      include ActiveModel::Validations
      include ActiveModel::Serializers::JSON

      attr_accessor :_id
      attr_accessor :_slugs
      attr_accessor :parent
      attr_accessor :created_at
      attr_accessor :updated_at

      alias id _id

      def initialize(attributes = {}, parent = nil)
        self.attributes = attributes
        self.parent = parent
        yield self if block_given?
      end

      def to_param
        if _slugs and !_slugs.empty?
          _slugs.first
        end
      end

      def ==(other)
        other.id == self.id
      end

      alias eql? ==

      def inspect
        {class: self.class.name, id: id}.merge!(attributes).to_s
      end

      def attributes
        {}
      end

      def attributes=(attributes)
        attributes ||= {}
        attributes.each_pair do |name, value|
          send("#{name}=", value) if respond_to?("#{name}=")
        end
      end

      def url(depth = 1)
        root = (@parent && depth > 0) ? @parent.url(depth-1) : Cornerstore.root_url
        "#{root}/#{self.class.name.split('::').last.underscore.pluralize}/#{id}"
      end

      def self.method_missing(method, *args, &block)
        if (self.const_defined?("Resource") and self.const_get("Resource").method_defined?(method)) or Array.method_defined?(method)
          self.const_get("Resource").new.send(method, *args, &block)
        else
          super
        end
      end

      def method_missing(method, *args, &block)
        if Writable.method_defined?(method)
          raise "Sorry, this part of the Cornerstore-API is currently read-only"
        else
          super
        end
      end
    end

    module Writable
      def new?
        id.nil?
      end

      def to_key
        new? ? [id] : nil
      end

      def save
        return false unless valid?
        wrapped_attributes = {self.class.name.split('::').last.underscore => self.attributes}
        if new?
          response = RestClient.post(url, wrapped_attributes, Cornerstore.headers){|response| response}
          self.attributes = ActiveSupport::JSON.decode(response)
        else
          response = RestClient.patch(url, wrapped_attributes, Cornerstore.headers){|response| response}
        end

        if response.success?
          return true
        else
          if data = ActiveSupport::JSON.decode(response) and data.has_key?('errors')
            data['errors'].each_pair do |key, messages|
              messages.map { |message| self.errors.add(key, message) }
            end

            return false
          else
            return false
          end
        end
      end

      def destroy
        RestClient.delete(url, Cornerstore.headers).success?
      end

      def self.create(attributes = {}, &block)
        self.new(attributes, &block).tap{|obj| obj.save}
      end
    end
  end
end