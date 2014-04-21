module Writefully
  module Workers
    class Journalist < BaseWorker
      def publish
        Writefully.logger.info "Publishing #{message[:resource]} #{message[:slug]}"
        pencil = Tools::Pencil.new_link(message)
        pencil.perform
      end

      def remove
        Writefully.logger.info "Removing #{message[:resource]} #{message[:slug]}"
      end

      def message_with_tries
        message.merge({ tries: (message[:tries] || 1) + 1 })
      end

      def on_death actor, reason
        Writefully.add_job :journalists, message_with_tries
      end
    end
  end
end