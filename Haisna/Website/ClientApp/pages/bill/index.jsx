import React from 'react';
import { Switch, Route } from 'react-router-dom';
import Menu from './Menu';
import PerBillSearch from '../../containers/bill/PerBillSearch';
import PerBillInfo from '../../containers/bill/PerBillInfo';
import CreatPerBill from '../../containers/bill/CreatePerBill';
import DmdAddUp from '../../containers/bill/DmdAddUp';
import DmdDeleteAllBill from '../../containers/bill/DmdDeleteAllBill';
import DmdPaymentFromCsv from '../../containers/bill/DmdPaymentFromCsv';
import DmdDecideAllPrice from '../../containers/bill/DmdDecideAllPrice';
import PerAddUp from '../../containers/bill/PerAddUp';
import DmdBurdenList from '../../containers/bill/DmdBurdenList';
import DmdSendCheckDay from '../../containers/bill/DmdSendCheckDay';
import DmdSendCheck from '../../containers/bill/DmdSendCheck';
import PerPaymentList from '../../containers/bill/PerPaymentList';
import PrtPerBill from '../../containers/bill/PrtPerBill';

const Demand = () => (
  <Switch>
    <Route exact path="/contents/demand" component={Menu} />
    <Route exact path="/contents/demand/perbill/perBillSearch" component={PerBillSearch} />
    <Route exact path="/contents/demand/perbill/info/:dmddate/:billseq/:branchno/:rsvno" component={PerBillInfo} />
    <Route exact path="/contents/demand/perbill/createPerBill/:dmddate/:billseq/:branchno/:mode" component={CreatPerBill} />
    <Route exact path="/contents/demand/perbill/createPerBill" component={CreatPerBill} />
    <Route exact path="/contents/demand/dmdaddup" component={DmdAddUp} />
    <Route exact path="/contents/demand/deleteDmd" component={DmdDeleteAllBill} />
    <Route exact path="/contents/demand/dmdPayment" component={DmdPaymentFromCsv} />
    <Route exact path="/contents/demand/dmdDecideAllPrice" component={DmdDecideAllPrice} />
    <Route exact path="/contents/demand/peraddup" component={PerAddUp} />
    <Route exact path="/contents/demand/burdenlist" component={DmdBurdenList} />
    <Route exact path="/contents/demand/dmdSendCheckDay" component={DmdSendCheckDay} />
    <Route exact path="/contents/demand/dmdSendCheck/:sendTime" component={DmdSendCheck} />
    <Route exact path="/contents/demand/perbill/perPaymentInfo/:rsvno" component={PerPaymentList} />
    <Route exact path="/contents/reserve/bill/prtPerBill/:dmddate/:billseq/:branchno/:prtKbn/:disp" component={PrtPerBill} />

  </Switch>
);

export default Demand;
