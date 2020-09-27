import React from 'react';
import { Switch, Route } from 'react-router-dom';

import Menu from './Menu';
import PerPaymentList from '../../containers/bill/PerPaymentList';

const Reserve = () => (
  <Switch>
    <Route exact path="/contents/reserve" component={Menu} />
    <Route exact path="/contents/bill/perpaymentlist" component={PerPaymentList} />
  </Switch>
);

export default Reserve;
