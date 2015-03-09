class Bitmap
    attr_reader :width, :height

    def self.from_source source
      data = obtain_data source
      width = obtain_width data
      height = obtain_height data
      new(width, height, source)
    end

    def initialize(width, height, source)
        set_source(source)
        @width = width
        @height = height
    end

    def wider_than? width
      @width > width
    end

    def print connection
      row_start = 0
      width_in_bytes = width / 8
      while row_start < height do
        chunk_height = ((height - row_start) > 255) ? 255 : (height - row_start)
        bytes = (0...(width_in_bytes * chunk_height)).map { @data.getbyte }

        connection.write_bytes(18, 42)
        connection.write_bytes(chunk_height, width_in_bytes)
        connection.write_bytes(*bytes)
        row_start += 255
      end
    end

    private

    def set_source(source)
      if source.respond_to?(:getbyte)
        @data = source
      else
        @data = StringIO.new(source.map(&:chr).join)
      end
    end

    def self.obtain_data source
      if source.respond_to?(:getbyte)
        data = source
      else
        data = StringIO.new(source.map(&:chr).join)
      end
      data
    end

    def self.obtain_height data
      tmp = data.getbyte
      height = (data.getbyte << 8) + tmp
      height
    end

    def self.obtain_width data
      tmp = data.getbyte
      width = (data.getbyte << 8) + tmp
      width
    end
  end
