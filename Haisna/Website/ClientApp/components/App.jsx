import React from 'react';
import { BrowserRouter, Route, Redirect } from 'react-router-dom';
import styled from 'styled-components';
import Axios from 'axios';
import { hot } from 'react-hot-loader';

import Maintenance from './preference/Maintenance';
import Reserve from '../pages/reserve/';
import Preference from '../pages/preference/';
import NaviBar from '../containers/common/NaviBar/NaviBar';
import ReportMenu from './report/ReportMenu';
import Report from '../pages/report/';
import Download from '../pages/download';

import Menu from '../example/Menu';
import Frontdoor from '../containers/reserve/Frontdoor';
import Followup from '../pages/followup/';
import Judgement from '../pages/judgement/';
import Result from '../pages/result/';
import Dailywork from '../pages/dailywork/';
import Bill from '../pages/bill/';

import Inquiry from '../pages/inquiry';

import Yudo from '../pages/yudo';

import './App.css';

const Content = styled.div`
  padding-top: 60px;
`;

class App extends React.Component {

  constructor() {
    super();

    this.state = {
      display: 'none',
    };
  }

  componentDidMount() {
    this.checkAuth();
  }

  checkAuth() {
    const app = this;

    Axios.get('/api/auth')
      .then(() => {
        app.setState({
          display: 'block',
        });
      })
      .catch((res) => {
        const { response } = res;

        if (response.status === 401) {
          window.location.href = '/login';
          return;
        }

        if (!response.data) {
          // eslint-disable-next-line no-alert
          alert('予期しない例外が発生しました。ログイン画面に戻ります。');
          window.location.href = '/login';
          return;
        }
        // eslint-disable-next-line no-alert
        alert(response.data.message);
      });
  }

  render() {
    return (
      <BrowserRouter>
        <div style={{ display: this.state.display }}>
          <NaviBar />
          <Content>
            <Route exact path="/" render={() => (<Redirect to="/reserve/frontdoor/todaysinfo" />)} />
            <Route path="/reserve/frontdoor/" component={Frontdoor} />
            <Route path="/report/" component={ReportMenu} />
            <Route path="/preference/maintenance/" component={Maintenance} />
            <Route path="/contents/reserve" component={Reserve} />
            <Route path="/contents/raiin" component={Preference} />
            <Route path="/contents/result" component={Result} />
            <Route path="/contents/judgement" component={Judgement} />
            <Route path="/contents/inquiry" component={Inquiry} />
            <Route path="/contents/report" component={Report} />
            <Route path="/contents/demand" component={Bill} />
            <Route path="/contents/download" component={Download} />
            <Route path="/contents/preference" component={Preference} />
            <Route path="/contents/followup" component={Followup} />
            <Route path="/contents/dailywork" component={Dailywork} />
            <Route path="/sample" component={Menu} />
            <Route path="/contents/yudo" component={Yudo} />
          </Content>
        </div>
      </BrowserRouter>
    );
  }
}

export default hot(module)(App);
