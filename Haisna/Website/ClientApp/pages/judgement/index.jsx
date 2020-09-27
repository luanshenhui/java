import React from 'react';
import { Switch, Route } from 'react-router-dom';

import InterviewTop from '../../containers/judgement/InterviewTop';
import SpecialInterViewTop from '../../containers/judgement/SpecialInterViewTop';

const Judgement = () => (
  <Switch>
    <Route path="/contents/judgement/interview/top/:rsvno" component={InterviewTop} />
    <Route exact path="/contents/judgement/specialinterview/:rsvno" component={SpecialInterViewTop} />
  </Switch>
);

export default Judgement;
