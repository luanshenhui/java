import { call, takeEvery, put } from 'redux-saga/effects';

import {
  OPEN_ADVICE_COMMENT_GUIDE_REQUEST,
  actions as judCmtStcActions,
} from '../../modules/preference/judCmtStcModule';

import judClassService from '../../services/preference/judClassService';
import judCmtStcService from '../../services/preference/judCmtStcService';

function* runOpenAdviceCommentGuide(action) {
  try {
    const { judClassCd } = action.payload;
    const searchModeFlg = 1;
    const judgesComments = yield call(judCmtStcService.getAdviceCommentList, { judClassCd, searchModeFlg });
    const judClass = yield call(judClassService.getJudClass, judClassCd);
    yield put(judCmtStcActions.openAdviceCommentGuideSuccess({ judClass, judgesComments }));
  } catch (error) {
    yield put(judCmtStcActions.openAdviceCommentGuideFailure(error.response));
  }
}

const judCmtStcSagas = [
  takeEvery(OPEN_ADVICE_COMMENT_GUIDE_REQUEST, runOpenAdviceCommentGuide),
];

export default judCmtStcSagas;
