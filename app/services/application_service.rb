class ApplicationService
  def initialize(*args, &block); end

  def execute
    raise NotImplementedError
  end

  class << self
    def execute(*args, &block)
      new(*args, &block).execute
    end
  end
end
