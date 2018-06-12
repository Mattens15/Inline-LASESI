# -*- encoding: utf-8 -*-
# stub: ruby_parser 3.11.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby_parser".freeze
  s.version = "3.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ryan Davis".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDPjCCAiagAwIBAgIBAjANBgkqhkiG9w0BAQUFADBFMRMwEQYDVQQDDApyeWFu\nZC1ydWJ5MRkwFwYKCZImiZPyLGQBGRYJemVuc3BpZGVyMRMwEQYKCZImiZPyLGQB\nGRYDY29tMB4XDTE3MTEyMTIxMTExMFoXDTE4MTEyMTIxMTExMFowRTETMBEGA1UE\nAwwKcnlhbmQtcnVieTEZMBcGCgmSJomT8ixkARkWCXplbnNwaWRlcjETMBEGCgmS\nJomT8ixkARkWA2NvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALda\nb9DCgK+627gPJkB6XfjZ1itoOQvpqH1EXScSaba9/S2VF22VYQbXU1xQXL/WzCkx\ntaCPaLmfYIaFcHHCSY4hYDJijRQkLxPeB3xbOfzfLoBDbjvx5JxgJxUjmGa7xhcT\noOvjtt5P8+GSK9zLzxQP0gVLS/D0FmoE44XuDr3iQkVS2ujU5zZL84mMNqNB1znh\nGiadM9GHRaDiaxuX0cIUBj19T01mVE2iymf9I6bEsiayK/n6QujtyCbTWsAS9Rqt\nqhtV7HJxNKuPj/JFH0D2cswvzznE/a5FOYO68g+YCuFi5L8wZuuM8zzdwjrWHqSV\ngBEfoTEGr7Zii72cx+sCAwEAAaM5MDcwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAw\nHQYDVR0OBBYEFEfFe9md/r/tj/Wmwpy+MI8d9k/hMA0GCSqGSIb3DQEBBQUAA4IB\nAQAfAXSQpsW7YSxd1csRtA/M4Zt0AMXFMd76GJ8Lgtg8G0+VFbdChRyDuDb0kPlW\nh9QQX/YABfCW8vxmssbMGrP+VGBAn7BbdTcfTlgCWrvMX1uL5aRL74nA4urKXqdW\na0nP70K4958P3GffBdtE3KGkU5xstFnXGajxuBRnL66E15KU0BNehVxdG258bdPu\nEKN6MqBPftFiev3tuwqDV11r2GquDpniYcT+Mi8/PgeAgVT/afBeVgbB3KaZeTRR\nAhXhF6Wi2GTMezlj5jlI5XV7WsJUSwTp/YiVvcmT74ZaCRvexm6EnNhkrvJJ1Xeu\nV+HB+LYYhXWitInO/eXxDrFB\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2018-02-15"
  s.description = "ruby_parser (RP) is a ruby parser written in pure ruby (utilizing\nracc--which does by default use a C extension). RP's output is\nthe same as ParseTree's output: s-expressions using ruby's arrays and\nbase types.\n\nAs an example:\n\n    def conditional1 arg1\n      return 1 if arg1 == 0\n      return 0\n    end\n\nbecomes:\n\n    s(:defn, :conditional1, s(:args, :arg1),\n      s(:if,\n        s(:call, s(:lvar, :arg1), :==, s(:lit, 0)),\n        s(:return, s(:lit, 1)),\n        nil),\n      s(:return, s(:lit, 0)))\n\nTested against 801,039 files from the latest of all rubygems (as of 2013-05):\n\n* 1.8 parser is at 99.9739% accuracy, 3.651 sigma\n* 1.9 parser is at 99.9940% accuracy, 4.013 sigma\n* 2.0 parser is at 99.9939% accuracy, 4.008 sigma".freeze
  s.email = ["ryand-ruby@zenspider.com".freeze]
  s.executables = ["ruby_parse".freeze, "ruby_parse_extract_error".freeze]
  s.extra_rdoc_files = ["History.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze]
  s.files = ["History.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze, "bin/ruby_parse".freeze, "bin/ruby_parse_extract_error".freeze]
  s.homepage = "https://github.com/seattlerb/ruby_parser".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "ruby_parser (RP) is a ruby parser written in pure ruby (utilizing racc--which does by default use a C extension)".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sexp_processor>.freeze, ["~> 4.9"])
      s.add_development_dependency(%q<rake>.freeze, ["< 11"])
      s.add_development_dependency(%q<oedipus_lex>.freeze, ["~> 2.5"])
      s.add_development_dependency(%q<rdoc>.freeze, ["< 6", ">= 4.0"])
      s.add_development_dependency(%q<racc>.freeze, ["~> 1.4.6"])
      s.add_development_dependency(%q<hoe>.freeze, ["~> 3.16"])
    else
      s.add_dependency(%q<sexp_processor>.freeze, ["~> 4.9"])
      s.add_dependency(%q<rake>.freeze, ["< 11"])
      s.add_dependency(%q<oedipus_lex>.freeze, ["~> 2.5"])
      s.add_dependency(%q<rdoc>.freeze, ["< 6", ">= 4.0"])
      s.add_dependency(%q<racc>.freeze, ["~> 1.4.6"])
      s.add_dependency(%q<hoe>.freeze, ["~> 3.16"])
    end
  else
    s.add_dependency(%q<sexp_processor>.freeze, ["~> 4.9"])
    s.add_dependency(%q<rake>.freeze, ["< 11"])
    s.add_dependency(%q<oedipus_lex>.freeze, ["~> 2.5"])
    s.add_dependency(%q<rdoc>.freeze, ["< 6", ">= 4.0"])
    s.add_dependency(%q<racc>.freeze, ["~> 1.4.6"])
    s.add_dependency(%q<hoe>.freeze, ["~> 3.16"])
  end
end
