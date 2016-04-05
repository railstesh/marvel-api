module Marvel
  class Properties
    class NullLogger

      def info(   msg)
        puts msg
      end
      def warn(   msg)
        puts msg
      end
      def debug(  msg)
        puts msg
      end
      def error(  msg)
        puts msg
      end
      def unknown(msg)
        puts msg
      end

      def tagged(tag) # yields
        yield
      end

    end
  end
end
