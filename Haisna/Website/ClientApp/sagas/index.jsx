import { all } from 'redux-saga/effects';

import billSaga from './bill/billSaga';
import decideAllConsultPriceSaga from './bill/decideAllConsultPriceSaga';
import demandSaga from './bill/demandSaga';
import perBillSaga from './bill/perBillSaga';
import bbsSaga from './common/bbsSaga';
import questionnaireSaga from './dailywork/questionnaireSaga';
import questionnaire1Saga from './dailywork/questionnaire1Saga';
import questionnaire2Saga from './dailywork/questionnaire2Saga';
import questionnaire3Saga from './dailywork/questionnaire3Saga';
import followSaga from './followup/followSaga';
import interviewSaga from './judgement/interviewSaga';
import specialinterviewSaga from './judgement/specialinterviewSaga';
import contractSaga from './preference/contractSaga';
import courseSaga from './preference/courseSaga';
import freeSaga from './preference/freeSaga';
import groupSaga from './preference/groupSaga';
import judCmtStcSaga from './preference/judCmtStcSaga';
import organizationSaga from './preference/organizationSaga';
import workStationSaga from './preference/workStationSaga';
import zipSaga from './preference/zipSaga';
import personSaga from './preference/personSaga';
import pubNoteSaga from './preference/pubNoteSaga';
import hainsLogSaga from './preference/hainsLogSaga';
import reportLogSaga from './report/reportLogSaga';
import reportSendDateSaga from './report/reportSendDateSaga';

import scheduleSaga from './preference/scheduleSaga';
import dmdAddUpSaga from './bill/dmdAddUpSaga';
import consultSaga from './reserve/consultSaga';
import webOrgRsvSaga from './reserve/webOrgRsvSaga';
import resultSaga from './result/resultSaga';
import sentenceGuideSaga from './common/sentenceGuideSaga';
import itemAndGroupGuideSaga from './common/itemAndGroupGuideSaga';
import paymentImportCsvSaga from './bill/paymentImportCsvSaga';
import mngAccuracySaga from './dailywork/mngAccuracySaga';
import inquirySaga from './inquiry/inquirySaga';
import morningReportSaga from './dailywork/morningReportSaga';
import failSafeSaga from './reserve/failSafeSaga';
import yudoSaga from './yudo/yudoSaga';

export default function* rootSaga() {
  yield all([
    ...billSaga,
    ...decideAllConsultPriceSaga,
    ...demandSaga,
    ...dmdAddUpSaga,
    ...perBillSaga,
    ...paymentImportCsvSaga,
    ...bbsSaga,
    ...questionnaireSaga,
    ...followSaga,
    ...interviewSaga,
    ...specialinterviewSaga,
    ...contractSaga,
    ...courseSaga,
    ...freeSaga,
    ...groupSaga,
    ...judCmtStcSaga,
    ...organizationSaga,
    ...workStationSaga,
    ...zipSaga,
    ...personSaga,
    ...pubNoteSaga,
    ...hainsLogSaga,
    ...reportLogSaga,
    ...reportSendDateSaga,
    ...scheduleSaga,
    ...consultSaga,
    ...resultSaga,
    ...sentenceGuideSaga,
    ...itemAndGroupGuideSaga,
    ...webOrgRsvSaga,
    ...failSafeSaga,
    ...inquirySaga,
    ...mngAccuracySaga,
    ...questionnaire1Saga,
    ...questionnaire2Saga,
    ...questionnaire3Saga,
    ...morningReportSaga,
    ...yudoSaga,
  ]);
}
