class Chunk
  MAX_HEIGHT = 255

  def initialize(width, height, bytes)
    @width_in_bytes = width / 8;
    @height = height
    @bytes = bytes
  end

  def print connection
    connection.write_bytes(18, 42)
    connection.write_bytes(@height, @width_in_bytes)
    connection.write_bytes(*@bytes)
  end
end