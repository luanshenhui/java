import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';

import mailConsultService from '../../services/reserve/mailConsultService';
import senderService from '../../services/reserve/senderService';


// Actionとその発生時に実行するメソッドをリンクさせる
const mailSagas = [

];

export default mailSagas;