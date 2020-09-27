import React from 'react';
import { Switch, Route } from 'react-router-dom';
import Menu from './Menu';
import OrgEdit from '../../containers/preference/organization/OrgEdit';
import OrgList from '../../containers/preference/organization/OrgList';

import MntPerInspection from '../../containers/preference/person/MntPerInspection';
import MntSearchPerson from '../../containers/preference/person/MntSearchPerson';
import MntPerson from '../../containers/preference/person/MntPerson';
import RsvFraSearch from '../../containers/preference/schedule/RsvFraSearch';
import MntCapacity from '../../containers/preference/schedule/MntCapacity';
import CtrSelectCourse from '../../containers/preference/contract/CtrSelectCourse';
import CtrPeriod from '../../containers/preference/contract/CtrPeriod';
import CtrBrowseOrg from '../../containers/preference/contract/CtrBrowseOrg';
import CtrBrowseContract from '../../containers/preference/contract/CtrBrowseContract';
import CtrFinished from '../../containers/preference/contract/CtrFinished';
import OrgHeader from '../../containers/preference/contract/OrgHeader';
import HainsLog from '../../containers/preference/log/HainsLog';
import MntCapacityList from '../../containers/preference/schedule/MntCapacityList';
import ReportSendCheck from '../../containers/preference/dispatch/ReportSendCheck';
import InqReportsInfo from '../../containers/preference/dispatch/InqReportsInfo';
import RsvFraCopy1 from '../../containers/preference/schedule/RsvFraCopy1';
import RsvFraCopy2 from '../../containers/preference/schedule/RsvFraCopy2';

const Preference = () => (
  <Switch>
    <Route exact path="/contents/preference" component={Menu} />

    <Route exact path="/contents/preference/organization" render={() => <OrgList target="org" />} />
    <Route exact path="/contents/preference/organization/edit" component={OrgEdit} />
    <Route exact path="/contents/preference/organization/edit/:orgcd1/:orgcd2" component={OrgEdit} />

    <Route exact path="/contents/preference/person" component={MntSearchPerson} />
    <Route exact path="/contents/preference/person/edit" component={MntPerson} />
    <Route exact path="/contents/preference/person/edit/:perid" component={MntPerson} />
    <Route exact path="/contents/preference/person/:perid/inspection" component={MntPerInspection} />
    <Route exact path="/contents/preference/schedule/rsvfra" component={RsvFraSearch} />
    <Route exact path="/contents/preference/schedule/mntcapacity" component={MntCapacity} />
    <Route exact path="/contents/preference/schedule/rsvfracopy1" component={RsvFraCopy1} />
    <Route exact path="/contents/preference/schedule/rsvfracopy2" component={RsvFraCopy2} />

    <Route path="/contents/preference/contract/organization" component={OrgHeader} />
    <Route exact path="/contents/preference/contract" render={() => <OrgList target="contract" />} />
    <Route exact path="/contents/preference/contract/:orgcd1/:orgcd2/course/:actmode" component={CtrSelectCourse} />
    <Route exact path="/contents/preference/contract/:opmode/:orgcd1/:orgcd2/:cscd/:ctrptcd/period" component={CtrPeriod} />
    <Route exact path="/contents/preference/contract/:opmode/:orgcd1/:orgcd2/:cscd/period" component={CtrPeriod} />
    <Route exact path="/contents/preference/contract/:opmode/organization/:orgcd1/:orgcd2/:cscd" component={CtrBrowseOrg} />
    <Route exact path="/contents/preference/contract/:opmode/organization/:orgcd1/:orgcd2/:cscd/:strdate/:enddate" component={CtrBrowseOrg} />
    <Route exact path="/contents/preference/contract/:opmode/:orgcd1/:orgcd2/:cscd/:reforgcd1/:reforgcd2/refcontracts" component={CtrBrowseContract} />
    <Route exact path="/contents/preference/contract/:opmode/:orgcd1/:orgcd2/:cscd/:reforgcd1/:reforgcd2/:strdate/:enddate/refcontracts" component={CtrBrowseContract} />
    <Route exact path="/contents/preference/contract/:orgcd1/:orgcd2/finish" component={CtrFinished} />
    <Route exact path="/contents/preference/hainslog" component={HainsLog} />
    <Route exact path="/contents/preference/schedule/capacity" component={MntCapacityList} />
    <Route exact path="/contents/preference/dispatch/sendCheck" component={ReportSendCheck} />
    <Route exact path="/contents/preference/dispatch/inqReportsInfo" component={InqReportsInfo} />
  </Switch>
);

export default Preference;
