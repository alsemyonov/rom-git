require 'rom/support/options'
require 'rom/support/constants'

require 'rom/gateway'
require 'rom/git/dataset'

module ROM
  module Git
    class Gateway < ROM::Gateway
      DEFAULT_BRANCH = 'refs/heads/master'.freeze
      include Options

      option :path, accept: String, reader: true

      option :branch, accept: String, reader: true, default: DEFAULT_BRANCH

      attr_reader :connection

      attr_reader :datasets

      attr_reader :repo

      def initialize(path, options = EMPTY_HASH)
        super
        @datasets = {}
        @repo = Rugged::Repository.new(path)
        reset_data
      end

      def [](name)
        datasets[name]
      end

      def dataset(name)
        datasets[name] = Dataset.new(
          connection, path: path, options: options, gateway: self
        )
      end

      def dataset?(name)
        datasets.key?(name)
      end

      def reset_data
        @connection = repo.references[branch].log
      end
    end
  end
end
