import React from 'react';
import { Switch, Route } from 'react-router-dom';
import Menu from './Menu';

import ShinsatsuReflesh from '../../containers/yudo/ShinsatsuReflesh';

const Yudo = () => (
  <Switch>
    <Route exact path="/contents/yudo" component={Menu} />
    <Route exact path="/contents/yudo/shinsatsureflesh" component={ShinsatsuReflesh} />
  </Switch>
);

export default Yudo;
