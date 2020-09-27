import React from 'react';
import axios from 'axios';
import qs from 'qs';

import Button from '../components/control/Button';

export default class LoginForm extends React.Component {

  constructor() {
    super();

    this.state = {
      username: '',
      password: '',
      token: '',
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleClickToken = this.handleClickToken.bind(this);
  }

  getToken() {
    const params = {
      username: this.state.username,
      password: this.state.password,
      grant_type: 'password',
    };

    // グループ一覧取得API呼び出し
    axios
      .post('/api/token', qs.stringify(params))
      .then((res) => {
        const data = res.data;
        const message = `"C:/hainsi/ExternalDevices/ConnectKetsuatsu/ConnectKetsuatsu/bin/Debug/ConnectKetsuatsu.exe" "${data.access_token}" "123" "456"`;
        this.setState({ token: message });
      })
      .catch(() => {
        // eslint-disable-next-line no-alert
        alert('ログインできませんでした');
      });
  }

  execAuth() {
    const params = {
      username: this.state.username,
      password: this.state.password,
    };

    // グループ一覧取得API呼び出し
    axios
      .post('/api/auth', qs.stringify(params))
      .then(() => {
        location.href = '/';
      })
      .catch((error) => {
        if (error.response.status === 400) {
          // eslint-disable-next-line no-alert
          alert(error.response.data.errors[0].message);
          return;
        }
        // eslint-disable-next-line no-alert
        alert('ログインできませんでした');
      });
  }

  handleSubmit(event) {
    event.preventDefault();
    this.execAuth();
  }

  handleChange(event) {
    const target = event.target;
    this.setState({ [target.name]: target.value });
  }

  handleClickToken() {
    this.getToken();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div style={{ display: 'table', margin: '300px auto' }}>
          <input type="text" style={{ width: 300 }} name="username" value={this.state.username} placeholder="ユーザID" onChange={this.handleChange} />
          <input type="password" style={{ width: 300 }} name="password" value={this.state.password} placeholder="パスワード" onChange={this.handleChange} />
          <div style={{ marginTop: 10 }}>
            <Button value="ログイン" />
            <Button onClick={this.handleClickToken} style={{ width: 120 }} value="トークン発行" />
          </div>
          <textarea value={this.state.token} style={{ width: 500, height: 200, marginTop: 30 }} />
        </div>
      </form>
    );
  }
}
