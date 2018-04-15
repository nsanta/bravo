require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'AuthData' do
  describe '.fetch' do
    it 'creates constants for todays data' do
      Bravo.constants.should_not include(:TOKEN, :SIGN)

      Bravo::AuthData.fetch

      Bravo.constants.should include(:TOKEN, :SIGN, :EXPIRE_AT)
    end
  end

  describe '.access_ticket_expired?' do
    it 'returns true when constant EXPIRED_AT does not exists' do
      Bravo.send(:remove_const, 'EXPIRE_AT')
      Bravo::AuthData.access_ticket_expired?.should eq true
    end

    context 'when access ticket has expired' do
      it 'returns true' do
        expired_at = Time.now - 54000 # 15 hours
        Bravo.const_set('EXPIRE_AT', expired_at)
        Bravo::AuthData.access_ticket_expired?.should eq true
      end
    end

    context 'when access ticket has not expired' do
      it 'returns false' do
        expire_at = Time.now + 54000 # 15 hours
        Bravo.const_set('EXPIRE_AT', expire_at)
        Bravo::AuthData.access_ticket_expired?.should eq false
      end
    end
  end
end
