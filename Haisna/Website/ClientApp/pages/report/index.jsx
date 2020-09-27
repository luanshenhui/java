import React from 'react';
import { Switch, Route } from 'react-router-dom';

import Menu from './Menu';
import ReserveList from '../../containers/report/ReserveList';
import InstructionList from '../../containers/report/InstructionList';
import WomanList from '../../containers/report/WomanList';
import SpecialList from '../../containers/report/SpecialList';
import WorkSheetLast from '../../containers/report/WorkSheetLast';
import EndoscopeCheck from '../../containers/report/EndoscopeCheck';
import WorkSheetPtn from '../../containers/report/WorkSheetPtn';
import Patient from '../../containers/report/Patient';
import NurseCheck from '../../containers/report/NurseCheck';
import WorkSheetCheck from '../../containers/report/WorkSheetCheck';
import WarningListNew from '../../containers/report/WarningListNew';
import PatientList from '../../containers/report/PatientList';
import ConsultCheck from '../../containers/report/ConsultCheck';
import Receivable from '../../containers/report/Receivable';
import EndoscopeDisinfection from '../../containers/report/EndoscopeDisinfection';
import EndoscopeList from '../../containers/report/EndoscopeList';
import Invitation from '../../containers/report/Invitation';
import FollowList from '../../containers/report/FollowList';
import AfterPostcard from '../../containers/report/AfterPostcard';
import Payment from '../../containers/report/Payment';
import PaymentList from '../../containers/report/PaymentList';
import ReportChecklist from '../../containers/report/ReportChecklist';
import PostList from '../../containers/report/PostList';
import CheckdoubleID from '../../containers/report/CheckdoubleID';
import AbsenceListBasic from '../../containers/report/AbsenceListBasic';
import AbsenceListJud from '../../containers/report/AbsenceListJud';
import BillCheck from '../../containers/report/BillCheck';
import BillRepCheck from '../../containers/report/BillRepCheck';
import OrgArrears from '../../containers/report/OrgArrears';
import AbsenceListStudy from '../../containers/report/AbsenceListStudy';
import OrgBill from '../../containers/report/OrgBill';
import AbsenceListJudCnt from '../../containers/report/AbsenceListJudCnt';
import DirectMail from '../../containers/report/DirectMail';
import AbsenceListNttData from '../../containers/report/AbsenceListNttData';
import AbsenceListKen from '../../containers/report/AbsenceListKen';
import CslMoneyList from '../../containers/report/CslMoneyList';
import OrganizationCsv from '../../containers/report/OrganizationCsv';
import AbsenceListResi from '../../containers/report/AbsenceListResi';
import BillConsultList from '../../containers/report/BillConsultList';
import BillDetailList from '../../containers/report/BillDetailList';
import AbsenceOrgBill from '../../containers/report/AbsenceOrgBill';
import Companyconduct from '../../containers/report/Companyconduct';
import AbsenceCompany from '../../containers/report/AbsenceCompany';
import ReportLog from '../../containers/report/ReportLog';
import Nameband from '../../containers/report/Nameband';
import Aneiho from '../../containers/report/Aneiho';
import AbsenceListBill from '../../containers/report/AbsenceListBill';
import SpeXMLdata from '../../containers/report/speXMLdata';
import CsvDatConsult from '../../containers/report/CsvDatConsult';
import PersonCsv from '../../containers/report/PersonCsv';
import AccountBook from '../../containers/report/AccountBook';
import PrtReport6 from '../../containers/report/PrtReport6';

const Report = () => (
  <Switch>
    <Route exact path="/contents/report" component={Menu} />
    <Route exact path="/contents/report/reservelist" component={ReserveList} />
    <Route exact path="/contents/report/instructionlist" component={InstructionList} />
    <Route exact path="/contents/report/womanlist" component={WomanList} />
    <Route exact path="/contents/report/speciallist" component={SpecialList} />
    <Route exact path="/contents/report/worksheetlast" component={WorkSheetLast} />
    <Route exact path="/contents/report/endoscopecheck2" component={EndoscopeCheck} />
    <Route exact path="/contents/report/worksheetptn" component={WorkSheetPtn} />
    <Route exact path="/contents/report/patient" component={Patient} />
    <Route exact path="/contents/report/nursecheck" component={NurseCheck} />
    <Route exact path="/contents/report/worksheetcheck" component={WorkSheetCheck} />
    <Route exact path="/contents/report/warninglistnew" component={WarningListNew} />
    <Route exact path="/contents/report/patientlist" component={PatientList} />
    <Route exact path="/contents/report/consultcheck" component={ConsultCheck} />
    <Route exact path="/contents/report/receivable" component={Receivable} />
    <Route exact path="/contents/report/endoscopedisinfection" component={EndoscopeDisinfection} />
    <Route exact path="/contents/report/endoscopelist" component={EndoscopeList} />
    <Route exact path="/contents/report/invitation" component={Invitation} />
    <Route exact path="/contents/report/followlist" component={FollowList} />
    <Route exact path="/contents/report/afterpostcard" component={AfterPostcard} />
    <Route exact path="/contents/report/payment" component={Payment} />
    <Route exact path="/contents/report/paymentlist" component={PaymentList} />
    <Route exact path="/contents/report/reportchecklist" component={ReportChecklist} />
    <Route exact path="/contents/report/postlist" component={PostList} />
    <Route exact path="/contents/report/checkdoubleid" component={CheckdoubleID} />
    <Route exact path="/contents/report/absencelistbasic" component={AbsenceListBasic} />
    <Route exact path="/contents/report/absencelistjud" component={AbsenceListJud} />
    <Route exact path="/contents/report/billcheck" component={BillCheck} />
    <Route exact path="/contents/report/billrepcheck" component={BillRepCheck} />
    <Route exact path="/contents/report/orgarrears" component={OrgArrears} />
    <Route exact path="/contents/report/absenceliststudy" component={AbsenceListStudy} />
    <Route exact path="/contents/report/orgbill" component={OrgBill} />
    <Route exact path="/contents/report/absencelistjudcnt" component={AbsenceListJudCnt} />
    <Route exact path="/contents/report/directmail" component={DirectMail} />
    <Route exact path="/contents/report/absencelistnttdata" component={AbsenceListNttData} />
    <Route exact path="/contents/report/absencelistken" component={AbsenceListKen} />
    <Route exact path="/contents/report/cslmoneylist" component={CslMoneyList} />
    <Route exact path="/contents/report/organizationcsv" component={OrganizationCsv} />
    <Route exact path="/contents/report/absencelistresi" component={AbsenceListResi} />
    <Route exact path="/contents/report/billconsultlist" component={BillConsultList} />
    <Route exact path="/contents/report/billdetaillist" component={BillDetailList} />
    <Route exact path="/contents/report/absenceorgbill" component={AbsenceOrgBill} />
    <Route exact path="/contents/report/companyconduct" component={Companyconduct} />
    <Route exact path="/contents/report/absencecompany" component={AbsenceCompany} />
    <Route exact path="/contents/report/nameband" component={Nameband} />
    <Route exact path="/contents/report/aneiho" component={Aneiho} />
    <Route exact path="/contents/report/absencelistbill" component={AbsenceListBill} />
    <Route exact path="/contents/report/reportLog" component={ReportLog} />
    <Route exact path="/contents/report/spexmldata" component={SpeXMLdata} />
    <Route exact path="/contents/report/csvdatconsult" component={CsvDatConsult} />
    <Route exact path="/contents/report/personcsv" component={PersonCsv} />
    <Route exact path="/contents/report/accountbook" component={AccountBook} />
    <Route exact path="/contents/report/report6" component={PrtReport6} />
  </Switch>
);

export default Report;
