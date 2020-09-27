import React from 'react';
import { Switch, Route } from 'react-router-dom';

import CtrContrctOrg from './CtrContrctOrg';

const OrgHeader = () => (
  <Switch>
    <Route path="/contents/preference/contract/organization/:orgcd1/:orgcd2" component={CtrContrctOrg} />
  </Switch>
);
export default OrgHeader;
