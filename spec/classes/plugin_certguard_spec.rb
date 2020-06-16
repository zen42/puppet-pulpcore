require 'spec_helper'

describe 'pulpcore::plugin::certguard' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      case os
      when /\-7-/
         it { is_expected.to contain_package('python3-subscription-manager-rhsm').with(ensure: 'present') }
      end
      it { is_expected.to contain_pulpcore__plugin('certguard') } 

      context 'with pulpcore' do
        let(:pre_condition) { 'include pulpcore' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('certguard')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
        end
      end
    end
  end
end