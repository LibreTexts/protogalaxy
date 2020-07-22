# frozen_string_literal: true

require 'spec_helper'

describe 'protogalaxy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do {
      } end
      it { is_expected.to compile }
    end
    context "init control plane node on #{os}" do
      let(:facts) { os_facts }
      let(:params) do {
        'role' => 'initial_control'
      } end
      it { is_expected.to compile }
    end
    context "additional control plane node on #{os}" do
      let(:facts) { os_facts }
      let(:params) do {
        'role' => 'control'
      } end
      it { is_expected.to compile }
    end
    context "init control plane node with custom interface on #{os}" do
      let(:facts) { os_facts }
      let(:params) do {
        'role' => 'initial_control',
        'network_interface' => os_facts[:networking]['primary']
      } end
      it { is_expected.to compile }
    end
    context "additional control plane node with custom interface on #{os}" do
      let(:facts) { os_facts }
      let(:params) do {
        'role' => 'control',
        'network_interface' => os_facts[:networking]['primary']
      } end
      it { is_expected.to compile }
    end
    context "worker node on #{os}" do
      let(:facts) { os_facts }
      let(:params) do {
        'role' => 'worker'
      } end
      it { is_expected.to compile }
    end
  end
end
