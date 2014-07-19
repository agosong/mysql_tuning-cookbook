# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'
require 'support/fake_recipe'
# require 'cookbook_helpers'
require 'mysql_helpers'
require 'mysql_helpers_cnf'
# require 'mysql_interpolator'

describe MysqlTuning::MysqlHelpers::Cnf do
  subject(:node) { FakeRecipe.new.node }

  context '#fix' do
    let(:cnf) do
      { 'mysqld' => {
        'slow_query_log' => 'ON',
        'slow_query_log_file' => 'foo'
      } }
    end

    it 'should not fix conigurations with new versions' do
      allow(MysqlTuning::MysqlHelpers)
        .to receive(:version) .and_return('5.5')
      expect(described_class.fix(
        cnf,
        node['mysql_tuning']['variables_block_size'],
        node['mysql_tuning']['old_names']
      )).to eql(cnf)
    end

    it 'should fix conigurations with old versions' do
      allow(MysqlTuning::MysqlHelpers)
        .to receive(:version).and_return('5.0')
      expect(described_class.fix(
        cnf,
        node['mysql_tuning']['variables_block_size'],
        node['mysql_tuning']['old_names']
      )).to eql('mysqld' => { 'log_slow_queries' => 'foo' })
    end

  end
end
