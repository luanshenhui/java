import React from 'react';
import { Switch, Route } from 'react-router-dom';

import Menu from './Menu';
import PersonCsv from '../../containers/download/PersonCsv';

const Report = () => (
  <Switch>
    <Route exact path="/contents/download" component={Menu} />
    <Route exact path="/contents/download/personcsv" component={PersonCsv} />
  </Switch>
);

export default Report;
