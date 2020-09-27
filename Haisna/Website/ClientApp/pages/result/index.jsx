import React from 'react';
import { Switch, Route } from 'react-router-dom';

import Menu from './Menu';
import Progress from '../../containers/result/Progress';
import RslAllSet from '../../containers/result/RslAllSet';
import RslListSet from '../../containers/result/RslListSet';
import RslMain from '../../containers/result/RslMain';

const Result = () => (
  <Switch>
    <Route exact path="/contents/result" component={Menu} />
    <Route exact path="/contents/result/progress" component={Progress} />
    <Route exact path="/contents/result/rslAllSet" component={RslAllSet} />
    <Route exact path="/contents/result/rslListSet" component={RslListSet} />
    <Route exact path="/contents/result/rslmain" component={RslMain} />
  </Switch>
);

export default Result;
