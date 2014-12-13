module SubdomainCompany
  def self.included( controller )
    controller.helper_method(:account_domain, :account_subdomain, :account_url,
                             :current_account, :default_account_subdomain, :default_account_url)
  end
    
  protected
  
  def default_account_subdomain
    ''
  end
  
  def account_url( account_subdomain = default_account_subdomain, use_ssl = request.ssl? )
    http_protocol(use_ssl) + account_host(account_subdomain)
  end
  
  def account_host( subdomain )
    account_host = ''
    account_host << subdomain + '.'
    account_host << account_domain
  end
  
  def account_domain
    account_domain = ''
    account_domain << request.domain + request.port_string
  end
  
  def account_subdomain
    request.subdomains(TLD_LENGTH).last || ''
  end
  
  def current_account
    @company ||= Company.find_by_subdomain(account_subdomain, :include => [:calculators])
  end
  
  def default_account_url( use_ssl = request.ssl? )
    http_protocol(use_ssl) + account_domain
  end
  
  def http_protocol( use_ssl = request.ssl? )
    (use_ssl ? "https://" : "http://")
  end

end