class GistService
  attr_accessor :gist, :error

  def self.view(link)
    new.find_gist(link.url)&.view
  end

  def view
    if gist?
      " #{gist.description} by #{gist.owner.login}"
    else
      error
    end
  end

  def gist?
    gist.instance_of?(Sawyer::Resource)
  end

  def find_gist(url)
    return unless url.start_with?('https://gist.github.com/')

    URI.parse(url).path.split('/').each do |path|
      self.gist = Octokit.gist(path) if path.length == 32
    rescue Octokit::NotFound
      self.error = ' gist not found'
    end
    self
  end
end
