
require 'logger'

class Log
  def self.this(str)
    STDOUT.puts str
    logger.info(str)
  end

  def self.error(str)
    STDOUT.puts str
    logger.fatal('Something went wrong')
    logger.fatal(str)
  end

  def self.succcessful_import(product)
    import_logger.info product.title
  end

  def self.up_to_date
    msg = 'Everything up to date!'
    STDOUT.puts msg
    logger.info msg
  end

  def self.import_logger
    Logger.new('./log/imported.log', 0, 5048576)
  end

  def self.logger
    Logger.new('./log/log.log')
  end
end
