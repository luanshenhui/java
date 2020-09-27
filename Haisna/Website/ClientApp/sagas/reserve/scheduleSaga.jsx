import { call, takeEvery, put } from 'redux-saga/effects';

import scheduleService from '../../services/reserve/scheduleService';

import {
  getRsvGrpListRequest,
  getRsvGrpListSuccess,
  getRsvGrpListFailure,
  getRsvGrpListAllRequest,
  getRsvGrpListAllSuccess,
  getRsvGrpListAllFailure,
} from '../../modules/reserve/scheduleModule';

function* runRequestRsvGrpList(action) {
  try {
    const payload = yield call(scheduleService.getRsvGrpList, action.payload);
    yield put(getRsvGrpListSuccess(payload));
  } catch (error) {
    yield put(getRsvGrpListFailure(error.response));
  }
}

function* runRequestRsvGrpListAll(action) {
  try {
    const payload = yield call(scheduleService.getRsvGrpListAll, action.payload);
    yield put(getRsvGrpListAllSuccess(payload));
  } catch (error) {
    yield put(getRsvGrpListAllFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const scheduleSagas = [
  takeEvery(getRsvGrpListRequest.toString(), runRequestRsvGrpList),
  takeEvery(getRsvGrpListAllRequest.toString(), runRequestRsvGrpListAll),
];

export default scheduleSagas;
