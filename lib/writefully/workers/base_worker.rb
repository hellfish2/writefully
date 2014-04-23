module Writefully
  module Workers
    class BaseWorker
      include Celluloid

      trap_exit :actor_died

      attr_reader :message

      def perform(message)
        @message = message
        self.__send__ message[:task]
      end

      def close_db_connection!
        ::ActiveRecord::Base.clear_active_connections! if defined?(::ActiveRecord)
      end

      def actor_died(actor, reason)
        Writefully.logger.error "An error occured #{reason.class} #{reason.message}"
        on_death(actor, reason) if self.respond_to?(:on_death)
      end
    end
  end
end