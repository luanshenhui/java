import React from 'react';
import { Route, Link } from 'react-router-dom';

import ReserveList from '../../containers/report/ReserveList';

const ReportMenu = () => (
  <div>
    <div style={{ float: 'left', width: 200 }}>
      <div style={{ marginTop: 10, marginLeft: 10 }}>
        <p><Link to="reservelist">予約者一覧表</Link></p>
      </div>
    </div>
    <div style={{ marginLeft: 200 }}>
      <Route exact path="/report/reservelist" component={ReserveList} />
    </div>
  </div>
);

export default ReportMenu;
