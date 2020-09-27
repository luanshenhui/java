import React from 'react';
import { Switch, Route } from 'react-router-dom';

import Menu from './Menu';
import ReserveMain from '../../containers/reserve/ReserveMain';
import FailSafe from '../../containers/reserve/FailSafe';
import PerPaymentList from '../../containers/bill/PerPaymentList';
import PerBillInfo from '../../containers/bill/PerBillInfo';
import RsvLogList from '../../containers/reserve/RsvLogList';
import PrtPerBill from '../../containers/bill/PrtPerBill';

const Reserve = () => (
  <Switch>
    <Route exact path="/contents/reserve" component={Menu} />
    <Route exact path="/contents/reserve/main" component={ReserveMain} />
    <Route exact path="/contents/reserve/main/:rsvno" component={ReserveMain} />
    <Route exact path="/contents/reserve/failsafe" component={FailSafe} />
    <Route exact path="/contents/reserve/rsvLog" component={RsvLogList} />
    <Route exact path="/contents/reserve/perpaymentlist/:rsvno" component={PerPaymentList} />
    <Route exact path="/contents/reserve/perBillInfo/:dmddate/:billseq/:branchno/:rsvno" component={PerBillInfo} />
    <Route exact path="/contents/reserve/prtPerBill/:dmddate/:billseq/:branchno/:prtKbn" component={PrtPerBill} />
    <Route exact path="/contents/reserve/prtPerBill/:dmddate/:billseq/:branchno/:prtKbn/:disp" component={PrtPerBill} />
  </Switch>
);

export default Reserve;
