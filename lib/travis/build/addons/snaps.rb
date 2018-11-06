require 'travis/build/addons/base'
require 'shellwords'

module Travis
  module Build
    class Addons
      class Snaps < Base
        SUPER_USER_SAFE = true
        SUPPORTED_OPERATING_SYSTEMS = [
          /^linux.*/
        ].freeze
        SUPPORTED_DISTS = %w(
          xenial
        ).freeze

        def before_prepare?
          # keeping empty for now
        end

        def before_prepare
          sh.fold('snap') do
            install_snaps unless config_snaps.empty?
          end
        end

        def before_configure?
          # keeping empty for now
        end

        def before_configure
          # keeping empty for now
        end
        
        def config
          @config ||= Hash(super)
        end

        def install_snaps
          sh.echo "Installing Snaps", ansi: :yellow

          # install core separately 
          sh.cmd "sudo snap install core", echo: true, timing: true

          config_snaps.each do |snap|
            sh.cmd "sudo snap install #{snap}", echo: true, timing: true
          end
        end

        def config_snaps
          @config_snaps ||= Array(config).flatten.compact
        rescue TypeError => e
          if e.message =~ /no implicit conversion of Symbol into Integer/
            raise Travis::Build::SnapsConfigError.new
          end
        end
      end
    end
  end
end