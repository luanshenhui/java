import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm, formValueSelector } from 'redux-form';
import { FieldGroup, FieldSet } from '../../components/Field';
import GuideBase from '../../components/common/GuideBase';
import { closeOcrNyuryoku } from '../../modules/dailywork/questionnaire1Module';
import OcrNyuryokuSpHeader201210 from './OcrNyuryokuSpHeader201210';
import OcrNyuryokuSpErr201210 from './OcrNyuryokuSpErr201210';
import OcrNyuryokuHeader from './OcrNyuryokuHeader';
import OcrNyuryokuBody from './OcrNyuryokuBody';
import OcrNyuryokuErr from './OcrNyuryokuErr';
import OcrNyuryokuSpHeader from './OcrNyuryokuSpHeader';
import OcrNyuryokuSpErr from './OcrNyuryokuSpErr';
import OcrNyuryokuSpHeader2 from './OcrNyuryokuSpHeader2';
import OcrNyuryokuSpBody2 from './OcrNyuryokuSpBody2';
import OcrNyuryokuSpErr2 from './OcrNyuryokuSpErr2';
import ChangeOptionGuide from './ChangeOptionGuide';
import NaishikyouCheckGuide from './NaishikyouCheckGuide';
import OcrNyuryokuSpBody from './OcrNyuryokuSpBody';
import OcrNyuryokuSpBody201210 from './OcrNyuryokuSpBody201210';
import * as constants from '../../constants/common';

const formName = 'OcrNyuryoku';

class OcrNyuryoku extends React.Component {
  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { closeflag, nomsg } = this.props;
    if (nextProps.closeflag !== closeflag && nextProps.closeflag === 'close' && nomsg !== 1) {
      if (nextProps.saveflag === 'OCR') {
        // eslint-disable-next-line no-alert,no-restricted-globals
        alert('ＯＣＲ結果が格納されていません。エラー内容を確認し、保存処理を必ず実行してください');
      } else if (nextProps.saveflag === 'GF') {
        // eslint-disable-next-line no-alert,no-restricted-globals
        alert('ＧＦコース受診の場合は、内視鏡チェックリストの保存処理を必ず実行してください。');
      }
    }
  }
  render() {
    // 引数値の取得
    const { data, pagename, rsvno } = this.props;
    const { checkcsldata, freedate, ret } = data;
    // フレームへのパラメータ設定
    const parmsrsvno = `${rsvno}`;
    // 汎用マスタより切り替え日
    let strchgdate = '';

    // const ret = false;
    let pagemode = '';
    if (ret !== null && ret !== undefined) {
      // 切替日以降の受診日であれば2012年版用の画面へ
      if (ret) {
        pagemode = 'ocrNyuryokuSp201210';
      } else if (!ret && data.freedate !== undefined) {
        // 汎用マスタより切り替え日取得
        if (freedate.length > 0 && freedate[0].freefield1 !== undefined) {
          strchgdate = moment(freedate[0].freefield1).format('YYYYMMDD');
        } else {
          strchgdate = moment(constants.CHECK_CSLDATE2).format('YYYYMMDD');
        }
        let strcsldate;
        let strcheckcscd;
        let flag = false;
        if (checkcsldata) {
          strcsldate = moment(checkcsldata.csldate).format('YYYYMMDD');
          strcheckcscd = checkcsldata.cscd;
          if (strcsldate > moment(constants.CHECK_CSLDATE).format('YYYYMMDD') &&
            (strcheckcscd === constants.CHECK_CSCD || strcheckcscd === constants.CHECK_CSCD_COMP)) {
            flag = true;
          }
        }
        if (flag) {
          if (strcsldate >= strchgdate) {
            pagemode = 'ocrNyuryokuSp2';
          } else {
            pagemode = 'ocrNyuryokuSp';
          }
        } else if (!flag) {
          if (strcsldate >= strchgdate) {
            pagemode = 'ocrNyuryokuSp2';
          } else {
            pagemode = 'ocrNyuryoku';
          }
        }
      }
    }
    let guideTitle = '';
    if (pagemode === 'ocrNyuryokuSp201210') {
      guideTitle = 'OCR入力結果確認（新）';
    } else if (pagemode === 'ocrNyuryoku') {
      guideTitle = 'OCR入力結果確認';
    } else if (pagemode === 'ocrNyuryokuSp') {
      guideTitle = 'OCR入力結果確認（新）';
    } else if (pagemode === 'ocrNyuryokuSp2') {
      guideTitle = 'OCR入力結果確認（新）';
    }
    return (
      <GuideBase {...this.props} title={guideTitle} usePagination={false}>
        <FieldGroup>
          {(pagemode === 'ocrNyuryokuSp201210' && pagename === 'info') &&
            <div>
              <FieldSet>
                <OcrNyuryokuSpHeader201210 rsvno={parmsrsvno} body={this.ocrNyuryokuSpBody201210} />
              </FieldSet>
              <FieldSet>
                <div id="OcrNyuryokuSpBody201210" style={{ overflowY: 'auto', overflowX: 'auto', width: '1450px', height: '550px' }}>
                  <OcrNyuryokuSpBody201210 rsvno={parmsrsvno} getInstance={(body) => { this.ocrNyuryokuSpBody201210 = body; }} />
                </div>
              </FieldSet>
              <FieldSet>
                <div id="OcrNyuryokuSpErr201210" style={{ overflowY: 'auto', overflowX: 'auto', width: '1420px', height: '170px' }}>
                  <OcrNyuryokuSpErr201210 rsvno={parmsrsvno} />
                </div>
              </FieldSet>
            </div>
          }
        </FieldGroup>
        <FieldGroup>
          {(pagemode === 'ocrNyuryokuSp' && pagename === 'info') &&
            <div>
              <FieldSet>
                <OcrNyuryokuSpHeader rsvno={parmsrsvno} body={this.OcrNyuryokuSpBody} />
              </FieldSet>
              <FieldSet>
                <div id="OcrNyuryokuSpBody" style={{ overflowY: 'auto', overflowX: 'auto', width: '1350px', height: '550px' }}>
                  <OcrNyuryokuSpBody rsvno={parmsrsvno} formName={formName} getInstance={(body) => { this.OcrNyuryokuSpBody = body; }} />
                </div>
              </FieldSet>
              <FieldSet>
                <div id="OcrNyuryokuSpErr" style={{ overflowY: 'auto', overflowX: 'auto', width: '1440px', height: '170px' }}>
                  <OcrNyuryokuSpErr rsvno={parmsrsvno} />
                </div>
              </FieldSet>
            </div>
          }
        </FieldGroup>
        <FieldGroup>
          {(pagemode === 'ocrNyuryokuSp2' && pagename === 'info') &&
            <div style={{ width: '100%' }}>
              <FieldSet>
                <OcrNyuryokuSpHeader2 rsvno={parmsrsvno} body={this.OcrNyuryokuSpBody2} />
              </FieldSet>
              <FieldSet>
                <div id="OcrNyuryokuSpBody2" style={{ overflowY: 'auto', overflowX: 'auto', width: '1830px', height: '500px' }}>
                  <OcrNyuryokuSpBody2 rsvno={parmsrsvno} getInstance={(body) => { this.OcrNyuryokuSpBody2 = body; }} />
                </div>
              </FieldSet>
              <FieldSet>
                <div id="OcrNyuryokuSpErr2" style={{ overflowY: 'auto', overflowX: 'auto', width: '1525px', height: '170px' }}>
                  <OcrNyuryokuSpErr2 rsvno={parmsrsvno} />
                </div>
              </FieldSet>
            </div>
          }
        </FieldGroup>
        <FieldGroup>
          {(pagemode === 'ocrNyuryoku' && pagename === 'info') &&
            <div>
              <FieldSet>
                <OcrNyuryokuHeader rsvno={parmsrsvno} body={this.ocrNyuryokuBody} />
              </FieldSet>
              <FieldSet>
                <div id="OcrNyuryokuBody" style={{ overflowY: 'auto', overflowX: 'auto', width: '1350px', height: '550px' }}>
                  <OcrNyuryokuBody rsvno={parmsrsvno} formName={formName} getInstance={(body) => { this.ocrNyuryokuBody = body; }} />
                </div>
              </FieldSet>
              <FieldSet>
                <div id="OcrNyuryokuErr" style={{ overflowY: 'auto', overflowX: 'auto', width: '1420px', height: '170px' }}>
                  <OcrNyuryokuErr rsvno={parmsrsvno} />
                </div>
              </FieldSet>
            </div>
          }
        </FieldGroup>
        <FieldGroup>
          {(pagename === 'changeOption') &&
            <FieldSet>
              <ChangeOptionGuide />
            </FieldSet>
          }
          {(pagename === 'NaishikyouCheck') &&
            <FieldSet>
              <NaishikyouCheckGuide />
            </FieldSet>
          }
        </FieldGroup>
      </GuideBase>
    );
  }
}

const OcrNyuryokuForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: false,
})(OcrNyuryoku);

// propTypesの定義
OcrNyuryoku.propTypes = {
  data: PropTypes.shape(),
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  pagename: PropTypes.string.isRequired,
  rsvno: PropTypes.string.isRequired,
  saveflag: PropTypes.string.isRequired,
  closeflag: PropTypes.string.isRequired,
  nomsg: PropTypes.number.isRequired,
};

OcrNyuryoku.defaultProps = {
  data: {},
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const selector = formValueSelector(formName);
  return {
    data: state.app.dailywork.questionnaire1.ocrNyuryoku.data,
    visible: state.app.dailywork.questionnaire1.ocrNyuryoku.visible,
    message: state.app.dailywork.questionnaire1.ocrNyuryoku.message,
    pagename: state.app.dailywork.questionnaire1.ocrNyuryoku.pagename,
    saveflag: state.app.dailywork.questionnaire1.ocrNyuryoku.saveflag,
    closeflag: state.app.dailywork.questionnaire1.ocrNyuryoku.closeflag,
    nomsg: selector(state, 'nomsg'),
  };
};

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    dispatch(closeOcrNyuryoku());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OcrNyuryokuForm);
