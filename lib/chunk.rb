class Chunk
  MAX_HEIGHT = 255

  def initialize(width, height, data)
    @width_in_bytes = width / 8
    @height = height
    @data = data
  end

  def print connection
    bytes = getBytes()

    write_bytes(connection, bytes)
  end

  private

  def write_bytes(connection, bytes)
    connection.write_bytes(18, 42)
    connection.write_bytes(@height, @width_in_bytes)
    connection.write_bytes(*bytes)
  end

  def getBytes()
    (0...(@width_in_bytes * @height)).map { @data.getbyte }
  end
end