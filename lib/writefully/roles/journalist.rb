module Writefully
  module Roles
    class Journalist
      include Celluloid

      trap_exit :handle_exit

      def initialize
        @pencil = Celluloid::Actor[:pencil]
        link @pencil
      end

      def publish(index)
        @pencil.pick_up(index, Writefully::Source.site_id)
        @pencil.async.write_content
        @pencil.async.write_assets
      end

      def handle_exit actor, reason
        # when writer fails we need to persist index to the queue so it can be retried
      end
    end
  end
end