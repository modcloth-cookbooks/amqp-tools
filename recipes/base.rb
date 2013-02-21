package 'golang'

bash 'build' do
  environment(
    'PATH' => %w{
        /opt/local/bin
        /opt/local/sbin
        /usr/bin
        /usr/sbin
        /bin
        /sbin
    }.join(':')
  )
  code <<-EOB
      set -e
      export GOPATH=$(go env GOROOT)
      go get -x -u github.com/modcloth/amqp-tools
      go install -x github.com/modcloth/amqp-tools/amqp-consume-cat
      go install -x github.com/modcloth/amqp-tools/amqp-publish-files
      ln -svf $GOPATH/bin/amqp-consume-cat #{node['install_prefix']}/bin/amqp-consume-cat
      ln -svf $GOPATH/bin/amqp-publish-files #{node['install_prefix']}/bin/amqp-publish-files
      chmod 0755 $GOPATH/bin/amqp-{consume-cat,publish-files}
  EOB
end
