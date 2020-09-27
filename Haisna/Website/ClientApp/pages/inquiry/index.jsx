import React from 'react';
import { Switch, Route } from 'react-router-dom';

import Inqwiz from '../../containers/inquiry/Inqwiz';

import InqMain from '../../containers/inquiry/InqMain';

const Reserve = () => (
  <Switch>
    <Route exact path="/contents/inquiry" component={Inqwiz} />
    <Route exact path="/contents/inquiry/inqMain/:perid" component={InqMain} />
  </Switch>
);

export default Reserve;
