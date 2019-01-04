describe Admin::User do
  context '#authenticate' do

    context 'when username or password blank' do
      it 'returns nil' do
        user = Admin::User.authenticate(username: '', password: '')
        expect(user).to be(nil)
      end
    end

    context 'when username does not match value in environment' do
      it 'returns nil' do
        user = Admin::User.authenticate(username: 'abc', password: '123')
        expect(user).to be(nil)
      end
    end

    context 'when username does not match username in environment' do
      it 'returns nil' do
        user = Admin::User.authenticate(username: 'abc', password: '123')
        expect(user).to be(nil)
      end
    end

    context 'when valid username and incorrect password' do
      it 'returns nil' do
        user = Admin::User.authenticate(username: 'username', password: '123')
        expect(user).to be(nil)
      end
    end

    context 'when valid username and password' do
      it 'returns the user' do
        user = Admin::User.authenticate(username: 'username', password: 'password')
        expect(user).to be_instance_of(Admin::User)
      end
    end
  end
end
