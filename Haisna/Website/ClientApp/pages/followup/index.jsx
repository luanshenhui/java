import React from 'react';
import { Switch, Route } from 'react-router-dom';

import Menu from './Menu';

import FollowInfoList from '../../containers/followup/FollowInfoList';

const Followup = () => (
  <Switch>
    <Route exact path="/contents/followup" component={Menu} />
    <Route exact path="/contents/followup/FollowInfoList" component={FollowInfoList} />
  </Switch>
);

export default Followup;
