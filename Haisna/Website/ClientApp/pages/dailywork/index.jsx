import React from 'react';
import { Switch, Route } from 'react-router-dom';

import Menu from './Menu';
import ReceiptFrontDoor from '../../containers/dailywork/ReceiptFrontDoor';
import PreparationInfo from '../../containers/dailywork/PreparationInfo';
import MngaccuracyInfo from '../../containers/dailywork/MngaccuracyInfo';
import MorningReportMain from '../../containers/dailywork/MorningReportMain';
import ocrNyuryoku from '../../containers/dailywork/OcrNyuryoku';

const Dailywork = () => (
  <Switch>
    <Route exact path="/contents/dailywork" component={Menu} />
    <Route exact path="/contents/dailywork/receiptfrontdoor" component={ReceiptFrontDoor} />
    <Route exact path="/contents/dailywork/preparationinfo/:rsvno" component={PreparationInfo} />
    <Route exact path="/contents/dailywork/MngaccuracyInfo" component={MngaccuracyInfo} />
    <Route exact path="/contents/dailywork/MorningReportMain" component={MorningReportMain} />
    <Route exact path="/contents/dailywork/ocrNyuryoku/:rsvno" component={ocrNyuryoku} />
  </Switch>
);

export default Dailywork;
