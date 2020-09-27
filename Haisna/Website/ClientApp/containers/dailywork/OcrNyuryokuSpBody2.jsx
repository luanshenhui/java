import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import { Field, blur, formValueSelector } from 'redux-form';

import MessageBanner from '../../components/MessageBanner';
import DropDown from '../../components/control/dropdown/DropDown';
import TextBox from '../../components/control/TextBox';
import DatePicker from '../../components/control/datepicker/DatePicker';
import SentenceGuide from './SentenceGuide';

import { getOcrNyuryokuSpBody2Request } from '../../modules/dailywork/questionnaire2Module';

import { OcrNyuryokuBody } from '../../constants/common';

const constants = OcrNyuryokuBody.OcrNyuryokuSpBody2;

const strArrCode1 = [
  '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
  '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
  '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
  '31', '32', '33', '34', '35', '36', '37', '38', '39', '40',
  '41', '42', '43', '44', '45', '46', '47', '48', '49', '50',
  '51', '52', '53', '54', '55',
  '56', '57', '58', '59', '60', '61', '62', '63', '65', '66',
  '67', '68', '69', '70', '71', '72', '73', '74', '75', '76',
  '98', '99',
  '101', '102', '103', '104', '105', '106', '107', '108', '109',
  '110', '111', '112', '113', '114', '115',
  '201', '202', '203', '204', '205', '206', '207', '208', '209', '210',
  '211', '212', '213', '214', '215', '216', '217',
  'XXX'];

const strArrName1 = [
  '脳腫瘍', '脳梗塞', 'クモ膜下出血', '脳出血', '一過性脳虚血発作', '緑内障', '白内障', '糖尿病網膜症', 'その他の眼科疾患', '甲状腺機能低下症',
  '甲状腺機能亢進症', '結核・胸膜炎', '肺がん', '肺線維症', '肺気腫', '気管支ぜんそく', '気管支拡張症', '慢性気管支炎', '高血圧', '狭心症',
  '心筋梗塞', '心房中隔欠損症', '心室中隔欠損症', '心臓弁膜症', '不整脈', '食道がん', '胃がん', '胃潰瘍', '胃ポリープ', '十二指腸潰瘍',
  '大腸がん', '大腸ポリープ', '虫垂炎', '痔', '胆石症', '胆のうポリープ', '慢性膵炎', '肝がん', 'Ｂ型肝炎', 'Ｃ型肝炎',
  '肝硬変', '腎炎・ネフローゼ', '腎結石', '尿路結石', '前立腺がん', '前立腺肥大', '脂質異常症（高脂血症）', '糖尿病', '血液疾患', '貧血',
  '痛風・高尿酸血症', '神経症', 'うつ病', '扁桃腺炎', '慢性腎不全',
  'パーキンソン', '肺炎', '慢性閉塞性肺疾患（COPD）：肺気腫を含む', '間質性肺炎', '気胸', '睡眠時無呼吸症候群', '非定型（非結核性）抗酸菌症', '糖尿病・高血糖', '食道静脈瘤', '逆流性食道炎',
  '食道ポリープ', 'ヘリコバクターピロリ感染症', '潰瘍性腸炎', 'クローン病', '虚血性腸炎', 'アルコール性肝障害', '脂肪肝', '難聴', '骨折', '骨粗しょう症',
  'その他', 'その他のがん',
  '子宮頚がん', '子宮体がん', '卵巣嚢腫（腫瘍）', '子宮内膜症', '子宮筋腫', '子宮細胞診異常', '乳がん', '乳腺症', '更年期障害',
  '子宮頸部細胞診異常', '子宮体部（内膜）細胞診異常', '内性子宮内膜症（子宮腺筋症）', '外性子宮内膜症（卵巣チョコレート嚢腫・子宮内膜症の', '卵巣腫瘍(悪性・がん・中間群・境界型)', '卵巣腫瘍（良性）',
  '甲状腺疾患', '膠原病', '急性膵炎', '大動脈瘤', '腸閉塞', '腎不全', '前立腺ＰＳＡ高値', 'その他の心疾患', 'その他の神経筋疾患', 'その他の上部消化管疾患',
  'その他の大腸疾患', 'その他の肝疾患', 'その他の前立腺疾患', 'その他の乳房疾患', '皮膚科疾患', '耳鼻科疾患', '整形外科疾患',
  '※入力異常'];

const strArrCode2 = [
  '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', 'XXX'];
const strArrName2 = [
  '手術後薬剤治療中',
  '手術後薬剤なし受診中',
  '内視鏡下切除後薬剤治療中',
  '内視鏡下切除後薬剤なし受診中',
  '薬剤治療中',
  '薬剤なし受診中',
  '手術後治療終了',
  '内視鏡下切除後治療終了',
  '治療終了',
  '放置あるいは治療中断',
  '透析治療中',
  '腹腔鏡下切除後・薬剤治療中',
  '腹腔鏡下切除後・薬剤なし受診中',
  '腹腔鏡下切除後・治療終了',
  '※入力異常'];

const strArrCode3 = ['1', '2', '3', '4', '5', 'XXX'];
const strArrName3 = ['父親', '母親', '兄弟・姉妹', '祖父母', 'おじ・おば', '※入力異常'];

// 自覚症状内容（コード）
const strArrCodeJikaku1 = [
  '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
  '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
  '21', '45', '46', '47', '48', '49', '22', '23', '24', '25',
  '26', '27', '28', '50', '51', '29', '30', '31', '52', '53',
  '54', '32', '33', '34', '35', '36', '37', '38', '39', '40',
  '41', '42', '43', '44', '55'];

// 自覚症状内容（名称）
const strArrNameJikaku1 = [
  '体重増加', '体重減少', '頭痛', '胸痛', '背部痛', '上腹部痛', '下腹部痛', '側腹部痛', '腰痛', '関節痛',
  '動悸', '不整脈の自覚', 'めまい', '食欲低下', '便秘', '下痢', '便通異常', '排便時の出血', '胃の調子が悪い', '口渇感',
  '息切れ', 'いびき', '咳がでる', '痰がでる', '咽頭痛', '鼻汁', '耳鳴り', '手足のしびれ', '手指のふるえ', '多汗',
  'むくみ', '排尿困難', '尿失禁', '頻尿', '尿の出が悪い', '月経不順', '月経痛', '不正出血', '更年期と思われる症状', '乳房の痛み',
  '乳房のしこり', '立ちくらみ', '肩こり', '眼精疲労', '聴力低下', '眼精疲労', '視力低下', '睡眠障害', '倦怠感', '焦燥感',
  '不安感', '抑うつ気分', '意欲低下', '仕事能力低下', '物忘れ'];

// 数値（コード）
const strArrCodeJikaku2 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];

// 数値（名称）
const strArrNameJikaku2 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];

// 単位（コード）
const strArrCodeJikaku3 = ['1', '2', '3', '4', '5'];

// 単位（名称）
const strArrNameJikaku3 = ['時間前', '日前', '週間前', 'ヶ月前', '年前'];

// 受診（コード）
const strArrCodeJikaku4 = ['1', '2'];

// 受診（名称）
const strArrNameJikaku4 = ['受診', '未受診'];

const nowDivWidth = 1200;
const nowDivEditHeadWidth = 1160;
const nowDivEditWidth = 1180;
const lstDivWidth = 300;

const formName = 'OcrNyuryoku';

let errInfoNo = 0;
class OcrNyuryokuSpBody2 extends React.Component {
  constructor(props) {
    super(props);
    const { getInstance } = props;
    if (typeof getInstance === 'function') {
      getInstance(this);
    }
  }

  componentDidMount() {
    const { rsvno, onLoad } = this.props;
    onLoad({ rsvno, formName });
    this.onBodyLoad();
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { act, lngErrCntE, lngErrCntW, setValue } = nextProps;

    this.onBodyLoad();

    if (act && act === 'check'
      // && (lngErrCntE > 0 || lngErrCntW > 0)) {
      && lngErrCntE === 0 && lngErrCntW > 0) {
      setValue('act', '');
      setValue('lngErrCntE', 0);
      setValue('lngErrCntW', 0);
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (confirm('警告がありますが、このまま保存しますか？')) {
        // モードを指定してsubmit
        this.save('save');
      }
    }
  }

  onBodyLoad = () => {
    const { ocrNyuryoku } = this.props;

    let i = 0;
    let strHtml;
    let elementId;

    for (i = 1; i <= errInfoNo; i += 1) {
      // マークを表示
      elementId = `Anchor-ErrInfo${i}`;
      if (document.all) {
        document.all(elementId).innerHTML = '';
      } else if (document.getElementById) {
        document.getElementById(elementId).innerHTML = '';
      }
    }
    if (ocrNyuryoku.errcount && ocrNyuryoku.errcount > 0) {
      for (i = 0; i < ocrNyuryoku.errcount; i += 1) {
        if (ocrNyuryoku.arrerrno[i] > 0) {
          switch (ocrNyuryoku.arrerrstate[i]) {
            case '1': // エラー
              strHtml = `<div style="border: 2px red solid; margin-right: 3px; height: 26px;"><span title=${ocrNyuryoku.arrerrmsg[i]} style="color: red; font-weight: bold;">E</span></div>`;
              break;
            case '2': // 警告
              strHtml = `<div style="border: 2px orange solid; margin-right: 3px; height: 26px;"><span title=${ocrNyuryoku.arrerrmsg[i]} style="color: orange; font-weight: bold;">I</span></div>`;
              break;
            default: break;
          }

          // マークを表示
          elementId = `Anchor-ErrInfo${ocrNyuryoku.arrerrno[i]}`;
          if (document.all) {
            document.all(elementId).innerHTML = strHtml;
          } else if (document.getElementById) {
            document.getElementById(elementId).innerHTML = strHtml;
          }
        }
      }
    }
  }

  // 今回値
  getCslDate = (ocrNyuryoku) => {
    if (ocrNyuryoku.ocrresult
      && ocrNyuryoku.ocrresult.length > 0
      && ocrNyuryoku.ocrresult[0].csldate
      && ocrNyuryoku.ocrresult[0].csldate !== '') {
      return moment(ocrNyuryoku.ocrresult[0].csldate).format('M/D/YYYY');
    }

    return '';
  }

  // 前回値
  getLstCslDate = (ocrNyuryoku) => {
    if (ocrNyuryoku.ocrresult
      && ocrNyuryoku.ocrresult.length > 0
      && ocrNyuryoku.ocrresult[0].lstcsldate
      && ocrNyuryoku.ocrresult[0].lstcsldate !== '') {
      return moment(ocrNyuryoku.ocrresult[0].lstcsldate).format('M/D/YYYY');
    }

    return '';
  }

  // 前回値
  getLstResultArea0 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      // センター使用欄
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>はい</span>); break;
        case '2': strLstRsl.push(<span>いいえ</span>); break;
        default: break;
      }

      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>　ＧＦ</span>);
        } else {
          strLstRsl.push(<span>ＧＦ</span>);
        }
      }

      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>　ＨＰＶ</span>);
        } else {
          strLstRsl.push(<span>ＨＰＶ</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 今回値
  getResultArea3 = (lngIndex) => {
    const { ocrNyuryoku, perResultGrp } = this.props;
    if (perResultGrp && perResultGrp.length > 0 && perResultGrp[0].result === '2') {
      ocrNyuryoku.ocrresult[lngIndex].result = '2';
      return (
        <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
          <span>　　可　　　</span>{this.editRsl(lngIndex, 'radio', 'opt1_0_2', 0, '2')}<span>否</span>
        </div>
      );
    }

    return (
      <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
        {this.editRsl(lngIndex, 'radio', 'opt1_0_2', 0, '1')}<span>可　　　</span>
        {this.editRsl(lngIndex, 'radio', 'opt1_0_2', 0, '2')}<span>否</span>
      </div>
    );
  }

  // 前回値
  getLstResultArea3 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>可</span>); break;
        case '2': strLstRsl.push(<span>否</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea4 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>はい</span>); break;
        case '2': strLstRsl.push(<span>いいえ</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea59 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>胃全摘手術</span>); break;
        case '2': strLstRsl.push(<span>胃部分切除</span>); break;
        case '3': strLstRsl.push(<span>内視鏡治療（粘膜切除術など）</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea60 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>ピロリ菌：除菌歴なし</span>); break;
        case '2': strLstRsl.push(<span>ピロリ菌：除菌歴あり、成功</span>); break;
        case '3': strLstRsl.push(<span>ピロリ菌：除菌歴あり、不成功</span>); break;
        case '4': strLstRsl.push(<span>ピロリ菌：除菌歴あり、除菌できたか不明</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea61 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult
        && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 食道ポリープ</span>);
        } else {
          strLstRsl.push(<span>食道ポリープ</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 胃がん</span>);
        } else {
          strLstRsl.push(<span>胃がん</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 慢性胃炎</span>);
        } else {
          strLstRsl.push(<span>慢性胃炎</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 胃ポリープ</span>);
        } else {
          strLstRsl.push(<span>胃ポリープ</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 4].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 胃潰瘍瘢痕</span>);
        } else {
          strLstRsl.push(<span>胃潰瘍瘢痕</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 5].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 5].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 十二指腸</span>);
        } else {
          strLstRsl.push(<span>十二指腸</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 6].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 6].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, その他</span>);
        } else {
          strLstRsl.push(<span>その他</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea68 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult
        && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 胆のうポリープ</span>);
        } else {
          strLstRsl.push(<span>胆のうポリープ</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 胆石</span>);
        } else {
          strLstRsl.push(<span>胆石</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 肝血管腫</span>);
        } else {
          strLstRsl.push(<span>肝血管腫</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 肝嚢胞</span>);
        } else {
          strLstRsl.push(<span>肝嚢胞</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 4].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 脂肪肝</span>);
        } else {
          strLstRsl.push(<span>脂肪肝</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 5].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 5].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 腎結石</span>);
        } else {
          strLstRsl.push(<span>腎結石</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea73 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex + 6].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 6].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 腎のう胞</span>);
        } else {
          strLstRsl.push(<span>腎のう胞</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 7].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 7].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 水腎症</span>);
        } else {
          strLstRsl.push(<span>水腎症</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 8].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 8].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 副腎腫瘍</span>);
        } else {
          strLstRsl.push(<span>副腎腫瘍</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 9].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 9].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, リンパ節腫大</span>);
        } else {
          strLstRsl.push(<span>リンパ節腫大</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 10].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 10].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, その他</span>);
        } else {
          strLstRsl.push(<span>その他</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea79 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult
        && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, ＷＰＷ症候群</span>);
        } else {
          strLstRsl.push(<span>ＷＰＷ症候群</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 完全右脚ブロック</span>);
        } else {
          strLstRsl.push(<span>完全右脚ブロック</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 不完全右脚ブロック</span>);
        } else {
          strLstRsl.push(<span>不完全右脚ブロック</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 不整脈</span>);
        } else {
          strLstRsl.push(<span>不整脈</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 4].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 右胸心</span>);
        } else {
          strLstRsl.push(<span>右胸心</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 5].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 5].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, その他</span>);
        } else {
          strLstRsl.push(<span>その他</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea85 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult
        && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 乳腺症</span>);
        } else {
          strLstRsl.push(<span>乳腺症</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 繊維線種</span>);
        } else {
          strLstRsl.push(<span>繊維線種</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 乳房形成術</span>);
        } else {
          strLstRsl.push(<span>乳房形成術</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, その他</span>);
        } else {
          strLstRsl.push(<span>その他</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea89 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>はい</span>); break;
        case '2': strLstRsl.push(<span>いいえ</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea90 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}ｋｇ</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea91 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>2ｋｇ以上増加した</span>); break;
        case '2': strLstRsl.push(<span>変動なし</span>); break;
        case '3': strLstRsl.push(<span>2ｋｇ以上減少した</span>); break;
        case '4': strLstRsl.push(<span>3ｋｇ以上増加した</span>); break;
        case '5': strLstRsl.push(<span>3ｋｇ以上減少した</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea92 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1':
          strLstRsl.push(<span>習慣的に飲む</span>);
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            strLstRsl.push(<span>{`（週${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}日）`}</span>);
          }
          break;
        case '2': strLstRsl.push(<span>ときどき飲む</span>); break;
        case '3': strLstRsl.push(<span>飲まない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea94 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}</span>);
        switch (lngIndex) {
          case 94: strLstRsl.push(<span>本（ビール大瓶）</span>); break;
          case 95: strLstRsl.push(<span>本（ビール３５０ml缶）</span>); break;
          case 96: strLstRsl.push(<span>本（ビール５００ml缶）</span>); break;
          case 97: strLstRsl.push(<span>本（日本酒）</span>); break;
          case 98: strLstRsl.push(<span>本（焼酎）</span>); break;
          case 99: strLstRsl.push(<span>本（ワイン）</span>); break;
          case 100: strLstRsl.push(<span>本（ウイスキー・ブランデー）</span>); break;
          case 101: strLstRsl.push(<span>本（その他）</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea102 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>吸っている</span>); break;
        case '2': strLstRsl.push(<span>吸わない</span>); break;
        case '3': strLstRsl.push(<span>過去に吸っていた</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea103 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}歳（吸い始めた年齢）</span>);
      }
      if (strLstRsl.length > 0) {
        strLstRsl.push(<span>, </span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}歳（やめた年齢）</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea105 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}本</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea106 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>思う</span>); break;
        case '2': strLstRsl.push(<span>思わない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea107 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}分</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea108 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>よく体を動かす</span>); break;
        case '2': strLstRsl.push(<span>普通に動いている</span>); break;
        case '3': strLstRsl.push(<span>あまり活動的でない</span>); break;
        case '4': strLstRsl.push(<span>ほとんど体を動かさない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea109 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>ほとんど毎日</span>); break;
        case '2': strLstRsl.push(<span>週３～５日</span>); break;
        case '3': strLstRsl.push(<span>週１～２日</span>); break;
        case '4': strLstRsl.push(<span>ほとんどしない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea110 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>はい</span>); break;
        case '2': strLstRsl.push(<span>寝不足を感じる</span>); break;
        default: break;
      }
      if (strLstRsl.length > 0) {
        strLstRsl.push(<span>, </span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        strLstRsl.push(<span>{`睡眠時間（${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}時間）`}</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        strLstRsl.push(<span>{`就寝時刻（${ocrNyuryoku.ocrresult[lngIndex + 2].lstresult}時）`}</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea113 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>毎食後に磨く</span>); break;
        case '2': strLstRsl.push(<span>１日１回は磨く</span>); break;
        case '3': strLstRsl.push(<span>１回も磨かない</span>); break;
        case '4': strLstRsl.push(<span>１日１～２回は磨く</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea114 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>肉体頭脳を要す労働</span>); break;
        case '2': strLstRsl.push(<span>主に肉体的な労働</span>); break;
        case '3': strLstRsl.push(<span>主に頭脳的な労働</span>); break;
        case '4': strLstRsl.push(<span>主に座り仕事</span>); break;
        case '5': strLstRsl.push(<span>特に仕事をもっていない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea115 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>週3日以上</span>); break;
        case '2': strLstRsl.push(<span>週2日以上</span>); break;
        case '3': strLstRsl.push(<span>週1日</span>); break;
        case '4': strLstRsl.push(<span>月3日以下</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea116 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>徒歩</span>); break;
        case '2': strLstRsl.push(<span>自転車</span>); break;
        case '3': strLstRsl.push(<span>自転車（２輪を含む）</span>); break;
        case '4': strLstRsl.push(<span>電車・バス</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea117 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (strLstRsl.length > 0) {
        strLstRsl.push(<span>, </span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}分（片道の通勤時間）`}</span>);
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}分（片道の移動時間）`}</span>);
      }

      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}分（片道の歩行時間）`}</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea118 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>あり</span>); break;
        case '2': strLstRsl.push(<span>なし</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea119 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      // 親 OCRGRP_START2 + 30
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        strLstRsl.push(<span>親</span>);
      }

      // 配偶者 OCRGRP_START2 + 31
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
        strLstRsl.push(<span>配偶者</span>);
      }

      // 子供 OCRGRP_START2 + 32
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult) {
        strLstRsl.push(<span>子供</span>);
      }

      // 独居 OCRGRP_START2 + 33
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult) {
        strLstRsl.push(<span>独居</span>);
      }

      // その他 OCRGRP_START2 + 34
      if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult) {
        strLstRsl.push(<span>その他</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea120 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>満足している</span>); break;
        case '2': strLstRsl.push(<span>やや満足している</span>); break;
        case '3': strLstRsl.push(<span>やや不満</span>); break;
        case '4': strLstRsl.push(<span>不満足</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea121 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>全く無かった</span>); break;
        case '2': strLstRsl.push(<span>ややつらいことがあった</span>); break;
        case '3': strLstRsl.push(<span>つらいことがあった</span>); break;
        case '4': strLstRsl.push(<span>大変つらかった</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea151 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>本人希望により未回答</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea152 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        switch (lngIndex) {
          case constants.OCRGRP_START3 + 1:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>全くない</span>); break;
              case '2': strLstRsl.push(<span>時にはある</span>); break;
              case '3': strLstRsl.push(<span>しばしばある</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 2:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>穏やかな方</span>); break;
              case '2': strLstRsl.push(<span>普通</span>); break;
              case '3': strLstRsl.push(<span>幾分激しい</span>); break;
              case '4': strLstRsl.push(<span>非常に激しい</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 3:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>全くない</span>); break;
              case '2': strLstRsl.push(<span>時々ある</span>); break;
              case '3': strLstRsl.push(<span>しばしばある</span>); break;
              case '4': strLstRsl.push(<span>いつもある</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 4:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>全くない</span>); break;
              case '2': strLstRsl.push(<span>あまりない</span>); break;
              case '3': strLstRsl.push(<span>ある</span>); break;
              case '4': strLstRsl.push(<span>非常にある</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 5:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>全くない</span>); break;
              case '2': strLstRsl.push(<span>時々ある</span>); break;
              case '3': strLstRsl.push(<span>時々ある</span>); break;
              case '4': strLstRsl.push(<span>常にある</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 6:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>よく遅れる</span>); break;
              case '2': strLstRsl.push(<span>時々遅れる</span>); break;
              case '3': strLstRsl.push(<span>決して遅れない</span>); break;
              case '4': strLstRsl.push(<span>30分前に行く</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 7:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>全くない</span>); break;
              case '2': strLstRsl.push(<span>時々ある</span>); break;
              case '3': strLstRsl.push(<span>しばしばある</span>); break;
              case '4': strLstRsl.push(<span>常にある</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 8:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>成り行き任せ</span>); break;
              case '2': strLstRsl.push(<span>1日単位に計画</span>); break;
              case '3': strLstRsl.push(<span>時間単位に計画</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 9:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>気が楽だと思う</span>); break;
              case '2': strLstRsl.push(<span>気にとめない</span>); break;
              case '3': strLstRsl.push(<span>嫌な気がする</span>); break;
              case '4': strLstRsl.push(<span>怒りを覚える</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 10:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>マイペース</span>); break;
              case '2': strLstRsl.push(<span>追越し返す</span>); break;
              default: break;
            }
            break;
          case constants.OCRGRP_START3 + 11:
            switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
              case '1': strLstRsl.push(<span>すぐになれる</span>); break;
              case '2': strLstRsl.push(<span>比較的早く</span>); break;
              case '3': strLstRsl.push(<span>少しイライラ</span>); break;
              case '4': strLstRsl.push(<span>八つ当たり</span>); break;
              default: break;
            }
            break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea163 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>本人希望により未回答</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea150 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>ほとんどなかった</span>); break;
        case '2': strLstRsl.push(<span>ときどきあった</span>); break;
        case '3': strLstRsl.push(<span>しばしばあった</span>); break;
        case '4': strLstRsl.push(<span>ほとんどいつもあった</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea0164btw0175 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      // センター使用欄
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>全くしない</span>); break;
        case '2': strLstRsl.push(<span>時にはある</span>); break;
        case '3': strLstRsl.push(<span>しばしばある</span>); break;
        case '4': strLstRsl.push(<span>常にある</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea176 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '6': strLstRsl.push(<span>1年未満</span>); break;
        case '7': strLstRsl.push(<span>1～3年前</span>); break;
        case '8': strLstRsl.push(<span>3年以上前</span>); break;
        case '5': strLstRsl.push(<span>受けたことなし</span>); break;
        // 前コード
        case '1': strLstRsl.push(<span>6ケ月以内</span>); break;
        case '2': strLstRsl.push(<span>6ケ月～1年以内</span>); break;
        case '3': strLstRsl.push(<span>1～2年以内</span>); break;
        case '4': strLstRsl.push(<span>3年前以上</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea177 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>異常なし</span>); break;
        case '2':
          strLstRsl.push(<span>異型上皮</span>);
          switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
            case '1': strLstRsl.push(<span>（クラス：Ⅲa）</span>); break;
            case '2': strLstRsl.push(<span>（クラス：Ⅲb）</span>); break;
            case '3': strLstRsl.push(<span>（クラス：Ⅲ）</span>); break;
            default: break;
          }
          break;
        // 前コード
        case '3': strLstRsl.push(<span>異常あり</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea179 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '4': strLstRsl.push(<span>当センター</span>); break;
        case '5': strLstRsl.push(<span>当病院</span>); break;
        case '6': strLstRsl.push(<span>他施設</span>); break;
        // 前コード
        case '1': strLstRsl.push(<span>当院</span>); break;
        case '2': strLstRsl.push(<span>他集団検診</span>); break;
        case '3': strLstRsl.push(<span>他医院・他病院</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea180 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>いいえ</span>); break;
        case '2': strLstRsl.push(<span>はい</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea181182 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1':
          strLstRsl.push(<span>異型上皮</span>);
          switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
            case '1': strLstRsl.push(<span>（クラス：Ⅲa）</span>); break;
            case '2': strLstRsl.push(<span>（クラス：Ⅲb）</span>); break;
            case '3': strLstRsl.push(<span>（クラス：Ⅲ）</span>); break;
            default: break;
          }
          break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea181 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '2': strLstRsl.push(<span>子宮頸がんの疑い</span>); break;
        case '9': strLstRsl.push(<span>その他</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea183 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>1年未満</span>); break;
        case '2': strLstRsl.push(<span>1～3年前</span>); break;
        case '3': strLstRsl.push(<span>3年以上前</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea184 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>当センター</span>); break;
        case '2': strLstRsl.push(<span>当病院</span>); break;
        case '3': strLstRsl.push(<span>他施設</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea185 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>いいえ</span>); break;
        case '2': strLstRsl.push(<span>はい</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea186 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '2': strLstRsl.push(<span>陰性</span>); break;
        case '9': strLstRsl.push(<span>陽性</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea187 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>1年未満</span>); break;
        case '2': strLstRsl.push(<span>1～3年前</span>); break;
        case '3': strLstRsl.push(<span>3年以上前</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea188 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>当センター</span>); break;
        case '2': strLstRsl.push(<span>当病院</span>); break;
        case '3': strLstRsl.push(<span>他施設</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea189 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>いいえ</span>); break;
        case '2': strLstRsl.push(<span>はい</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea190191 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>異常なし</span>); break;
        case '2':
          strLstRsl.push(<span>擬陽性</span>);
          switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
            case '1': strLstRsl.push(<span>（クラス：Ⅲa）</span>); break;
            case '2': strLstRsl.push(<span>（クラス：Ⅲb）</span>); break;
            case '3': strLstRsl.push(<span>（クラス：Ⅲ）</span>); break;
            default: break;
          }
          break;
        case '3': strLstRsl.push(<span>異常あり</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea190 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '3': strLstRsl.push(<span>子宮体がんの疑い</span>); break;
        case '9': strLstRsl.push(<span>その他</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea192 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>1年未満</span>); break;
        case '2': strLstRsl.push(<span>1～3年前</span>); break;
        case '3': strLstRsl.push(<span>3年以上前</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea193 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>当センター</span>); break;
        case '2': strLstRsl.push(<span>当病院</span>); break;
        case '3': strLstRsl.push(<span>他施設</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea194 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>ない</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮筋腫</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮頸管ポリープ</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea197 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>内性子宮内膜症（子宮腺筋症）</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>外性子宮内膜症（チョコレートのう胞など）</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea199 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮頸がん</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮体がん</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>卵巣がん</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 4].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 4].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮頸がん</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea202 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>良性卵巣腫瘍（右）</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>良性卵巣腫瘍（左）</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>繊毛性疾患</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 0].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 0].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>卵巣腫瘍（右）</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 2].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>卵巣腫瘍（左）</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea205 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>付属器炎</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>膣炎</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>膀胱子宮脱</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea208 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>乳がん</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>その他</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 3].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>月経異常</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 5].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 5].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>不妊</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 1].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮内膜症</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 6].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 6].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>びらん</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea210no1 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>受けたことなし</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea210no2 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '2':
          strLstRsl.push(<span>ある→　</span>);
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 1]}歳から`}</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
            strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 2]}年間`}</span>);
          }
          break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea213 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '2': strLstRsl.push(<span>現在不妊治療中</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea214 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>受けたことなし</span>); break;
        case '2': strLstRsl.push(<span>はい</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea215 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>右卵巣</span>);
      }
      // 前コード
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18].lstresult === '4'
        && (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18 + 2].lstresult === '7'
          || ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18 + 2].lstresult === '9')) {
        if (strLstRsl.length > 0) {
          strLstRsl.splice(0, 1);
        }
        strLstRsl.push(<span>右卵巣</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea216 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
          case '1': strLstRsl.push(<span>　良性</span>); break;
          case '2': strLstRsl.push(<span>　境界型</span>); break;
          case '3': strLstRsl.push(<span>　悪性</span>); break;
          default: break;
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
          case '1': strLstRsl.push(<span>　全摘</span>); break;
          case '2': strLstRsl.push(<span>　部分切除</span>); break;
          default: break;
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex + 2].lstresult}歳`}</span>);
      }
      // 前コード
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18].lstresult === '4'
        && (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18 + 2].lstresult === '7'
          || ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18 + 2].lstresult === '9')) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 19].lstresult
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 19].lstresult !== '') {
          strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 19].lstresult}歳`}</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult) {
          case '1': strLstRsl.push(<span>　当院</span>); break;
          case '2': strLstRsl.push(<span>　他院</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea220 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>左卵巣</span>);
      }
      // 前コード
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18].lstresult === '4'
        && (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18 + 2].lstresult === '8'
          || ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18 + 2].lstresult === '9')) {
        if (strLstRsl.length > 0) {
          strLstRsl.splice(0, 1);
        }
        strLstRsl.push(<span>左卵巣</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea221 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
          case '1': strLstRsl.push(<span>　良性</span>); break;
          case '2': strLstRsl.push(<span>　境界型</span>); break;
          case '3': strLstRsl.push(<span>　悪性</span>); break;
          default: break;
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
          case '1': strLstRsl.push(<span>　全摘</span>); break;
          case '2': strLstRsl.push(<span>　部分切除</span>); break;
          default: break;
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex + 2].lstresult}歳`}</span>);
      }
      // 前コード
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18].lstresult === '4'
        && (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18 + 2].lstresult === '8'
          || ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 18 + 2].lstresult === '9')) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 19].lstresult
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 19].lstresult !== '') {
          strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 19].lstresult}歳`}</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult) {
          case '1': strLstRsl.push(<span>　当院</span>); break;
          case '2': strLstRsl.push(<span>　他院</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea225 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>子宮全摘術</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea226 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
          case '1': strLstRsl.push(<span>　膣式</span>); break;
          case '2': strLstRsl.push(<span>　腹式</span>); break;
          case '3': strLstRsl.push(<span>　その他</span>); break;
          default: break;
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}歳`}</span>);
      }
      // 前コード
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult === '4'
        && (ocrNyuryoku.ocrresult[lngIndex + 1 + 2].lstresult === '8'
        || ocrNyuryoku.ocrresult[lngIndex + 1 + 2].lstresult === '9')) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 17].lstresult
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 17].lstresult !== '') {
          strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 17].lstresult}歳`}</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult) {
          case '1': strLstRsl.push(<span>　当院</span>); break;
          case '2': strLstRsl.push(<span>　他院</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea229 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>広汎子宮全摘術</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea230 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}歳`}</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
          case '1': strLstRsl.push(<span>　当院</span>); break;
          case '2': strLstRsl.push(<span>　他院</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea232 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>子宮頸部円錐切除術</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea233 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}歳`}</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
          case '1': strLstRsl.push(<span>　当院</span>); break;
          case '2': strLstRsl.push(<span>　他院</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea235 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>子宮筋腫核出術</span>);
      }
      // 前コード
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 16].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 16].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.splice(0, 1);
        }
        strLstRsl.push(<span>子宮筋腫核出術</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea236 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}歳`}</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 17].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 17].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 17].lstresult}歳`}</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
          case '1': strLstRsl.push(<span>　当院</span>); break;
          case '2': strLstRsl.push(<span>　他院</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea238 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>子宮膣上部切断術（子宮頸部残存）</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea239 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}歳`}</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
          case '1': strLstRsl.push(<span>　当院</span>); break;
          case '2': strLstRsl.push(<span>　他院</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea241 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>その他の手術</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea242 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}歳`}</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
          case '1': strLstRsl.push(<span>　当院</span>); break;
          case '2': strLstRsl.push(<span>　他院</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea244 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
          case '1': strLstRsl.push(<span>ない</span>); break;
          case '2': strLstRsl.push(<span>ある</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea245 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
          case '1': strLstRsl.push(<span>ない</span>); break;
          case '2': strLstRsl.push(<span>ある</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea246no1 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}回</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea246no2 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}回</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        strLstRsl.push(<span>（帝王切開：{ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}回</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea249no1 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>いいえ</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea249no2 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '2':
          strLstRsl.push(<span>はい→</span>);
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}歳</span>);
          }
          break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea251256 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}年</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}月</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex + 2].lstresult}日</span>);
      }
      strLstRsl.push(<span>～</span>);
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex + 3].lstresult}月</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult && ocrNyuryoku.ocrresult[lngIndex + 4].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex + 4].lstresult}日</span>);
      }
      if (strLstRsl.length === 1) {
        strLstRsl.splice(0, 1);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea261 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>少ない</span>); break;
        case '2': strLstRsl.push(<span>ふつう</span>); break;
        case '3': strLstRsl.push(<span>多い</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea262 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '4': strLstRsl.push(<span>軽い</span>); break;
        case '5': strLstRsl.push(<span>ふつう</span>); break;
        case '6': strLstRsl.push(<span>強い</span>); break;
        // 前コード
        case '1': strLstRsl.push(<span>ない、又は軽い痛み</span>); break;
        case '2': strLstRsl.push(<span>強い痛みが時々ある</span>); break;
        case '3': strLstRsl.push(<span>毎回ひどい痛みがある</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea263no1= (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>ない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea263no2= (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '2':
        case '3':
        case '4':
          strLstRsl.push(<span>ある</span>);
          // 前コード
          switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
            case '2': strLstRsl.push(<span>（１年以内にある）</span>); break;
            case '3': strLstRsl.push(<span>（１年以上前にある）</span>); break;
            default: break;
          }
          switch (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult) {
            case '1': strLstRsl.push(<span>→閉経後出血</span>); break;
            case '2': strLstRsl.push(<span>→性交時出血</span>); break;
            case '3': strLstRsl.push(<span>→その他の出血</span>); break;
            default: break;
          }
          break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea265no1 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>ない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea265no2 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      strLstRsl.push(<span>はい→</span>);
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '4':
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>下腹部痛（月経痛以外で）</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>おりもの（水様性）</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>おりもの（血液、茶色含む）</span>);
          }
          break;
        default: break;
      }
      // 前コード
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 7].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 7].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>おりものが気になる</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 8].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 8].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>陰部がかゆい</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 9].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 9].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>下腹部が痛い</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 10].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 10].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>更年期症状がつらい</span>);
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 11].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 11].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>性交時に出血する</span>);
      }
      if (strLstRsl.length === 1) {
        strLstRsl.splice(0, 1);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea269 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>いない</span>); break;
        case '10': strLstRsl.push(<span>いる</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea270 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1':
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他血縁</span>);
          }
          break;
        default: break;
      }
      switch (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 12].lstresult) {
        case '6':
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他</span>);
          }
          break;
        default: break;
      }
      if (strLstRsl.length > 0) {
        strLstRsl.push(<span>子宮頸がん→</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea253 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1':
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他血縁</span>);
          }
          break;
        default: break;
      }
      // 前コード
      switch (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 12].lstresult) {
        case '6':
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他</span>);
          }
          break;
        default: break;
      }
      if (strLstRsl.length > 0) {
        strLstRsl.unshift(<span>子宮頸がん→</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea274 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '5':
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他血縁</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他</span>);
          }
          break;
        default: break;
      }
      if (strLstRsl.length > 0) {
        strLstRsl.unshift(<span>子宮体がん→</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea278 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '7':
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他血縁</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他</span>);
          }
          break;
        default: break;
      }
      if (strLstRsl.length > 0) {
        strLstRsl.unshift(<span>卵巣がん→</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea282 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '9':
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他血縁</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他</span>);
          }
          break;
        default: break;
      }
      if (strLstRsl.length > 0) {
        strLstRsl.unshift(<span>その他の婦人科がん→</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea286 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '8':
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他血縁</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 13].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実母</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 14].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>実姉妹</span>);
          }
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult && ocrNyuryoku.ocrresult[constants.OCRGRP_START_Z + 15].lstresult !== '') {
            if (strLstRsl.length > 0) {
              strLstRsl.push(<span>, </span>);
            }
            strLstRsl.push(<span>その他</span>);
          }
          break;
        default: break;
      }
      if (strLstRsl.length > 0) {
        strLstRsl.unshift(<span>乳がん→</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea302 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (lngIndex) {
        case 285:
          switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
            case '1': strLstRsl.push(<span>よく食べる</span>); break;
            case '2': strLstRsl.push(<span>時々食べる</span>); break;
            case '3': strLstRsl.push(<span>ほとんど食べない</span>); break;
            default: break;
          }
          break;
        case 286:
        case 287:
          switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
            case '1': strLstRsl.push(<span>毎食食べる</span>); break;
            case '2': strLstRsl.push(<span>１日２食食べる</span>); break;
            case '3': strLstRsl.push(<span>１日１食食べる</span>); break;
            case '4': strLstRsl.push(<span>ほとんど食べない</span>); break;
            default: break;
          }
          break;
        case 288:
          switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
            case '1': strLstRsl.push(<span>１日７皿以上</span>); break;
            case '2': strLstRsl.push(<span>１日５～６皿</span>); break;
            case '3': strLstRsl.push(<span>１日３～４皿</span>); break;
            case '4': strLstRsl.push(<span>１日１～２皿</span>); break;
            case '5': strLstRsl.push(<span>毎日は食べない</span>); break;
            case '6': strLstRsl.push(<span>ほとんど食べない</span>); break;
            default: break;
          }
          break;
        case 289:
          switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
            case '1': strLstRsl.push(<span>１日３皿以上</span>); break;
            case '2': strLstRsl.push(<span>１日２皿以上</span>); break;
            case '3': strLstRsl.push(<span>１日１皿</span>); break;
            case '4': strLstRsl.push(<span>週に３～４皿</span>); break;
            case '5': strLstRsl.push(<span>週に１～２皿</span>); break;
            case '6': strLstRsl.push(<span>ほとんど食べない</span>); break;
            default: break;
          }
          break;
        case 290:
          switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
            case '1': strLstRsl.push(<span>１日１．５杯以上</span>); break;
            case '2': strLstRsl.push(<span>１日１杯</span>); break;
            case '3': strLstRsl.push(<span>週に３～４杯</span>); break;
            case '4': strLstRsl.push(<span>週に１～２杯</span>); break;
            case '5': strLstRsl.push(<span>ほとんど食べない</span>); break;
            default: break;
          }
          break;
        case 291:
        case 292:
        case 293:
          switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
            case '1': strLstRsl.push(<span>週５日以上食べる</span>); break;
            case '2': strLstRsl.push(<span>週３～４日食べる</span>); break;
            case '3': strLstRsl.push(<span>週１～２日食べる</span>); break;
            case '4': strLstRsl.push(<span>ほとんど食べない</span>); break;
            default: break;
          }
          break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea311 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>はい</span>); break;
        case '2': strLstRsl.push(<span>いいえ</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea575 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>①改善するつもりはない</span>); break;
        case '2': strLstRsl.push(<span>②改善するつもりである（概ね6ヶ月以内）</span>); break;
        case '3': strLstRsl.push(<span>③近いうちに（概ね1ヶ月以内）改善するつもりであり、少しずつはじめている</span>); break;
        case '4': strLstRsl.push(<span>④既に改善に取り組んでいる（6ヶ月未満）</span>); break;
        case '5': strLstRsl.push(<span>⑤既に改善に取り組んでいる（6ヶ月以上）</span>); break;
        case '6': strLstRsl.push(<span>未回答</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea576 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>①改善するつもりはない</span>); break;
        case '2': strLstRsl.push(<span>②改善するつもりである（概ね6ヶ月以内）</span>); break;
        case '6': strLstRsl.push(<span>未回答</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 現病歴 １－a．
  getDisease1aArea = () => {
    const { ocrNyuryoku } = this.props;
    const strDisease = [];
    let i;
    let j;
    let strLstDiffMsg;
    let strLstRsl;

    for (i = 0; i < constants.NOWDISEASE_COUNT; i += 1) {
      // 前回値と比較してメッセージを作成
      strLstDiffMsg = '';
      for (j = 0; j < constants.NOWDISEASE_COUNT; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 5 + i * 3].result
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 5 + i * 3].result !== '') {
          // 同じ病名を検索
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 5 + i * 3].result === ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 5 + j * 3].lstresult) {
            // 年齢が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 6 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 6 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '年齢';
            }
            // 治療状態が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 7 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 7 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '治療状態';
            }
          }
        }
      }

      strLstRsl = '';
      for (j = 0; j < strArrCode1.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 5 + i * 3].lstresult === strArrCode1[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName1[j];
          break;
        }
      }
      strLstRsl += (strLstRsl === '' ? '' : ' ');
      strLstRsl += (!ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 6 + i * 3].lstresult
        || ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 6 + i * 3].lstresult === '' ? '' : `${ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 6 + i * 3].lstresult}才`);
      for (j = 0; j < strArrCode2.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 7 + i * 3].lstresult === strArrCode2[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName2[j];
          break;
        }
      }

      strDisease.push((
        <div key={`NOWDISEASE_${i}`}>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: '45px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 5 + i * 3, 'disease', `${i}`, 3, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '405px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 5 + i * 3, 'list1', `list1_1_1[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 6 + i * 3, 'text', `Rsl[${constants.OCRGRP_START1 + 6 + i * 3}]`, 3, '')}才
          </div>
          <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 7 + i * 3, 'list2', `list1_1_2[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '164px', marginTop: '2px', marginLeft: '2px' }}>
            {strLstDiffMsg !== '' && <span style={{ color: 'red', fontWeight: 'bold', fontSize: '15px' }}>※{strLstDiffMsg}違い</span>}
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '2px', marginLeft: '300px' }}>
            {strLstRsl}
          </div>
          <div style={{ clear: 'left' }} />
        </div>
      ));
    }
    return strDisease;
  }

  // 既往歴 １－b．
  getDisease1bArea = () => {
    const { ocrNyuryoku } = this.props;
    const strDisease = [];
    let i;
    let j;
    let strLstDiffMsg;
    let strLstRsl;

    for (i = 0; i < constants.DISEASEHIST_COUNT; i += 1) {
      // 前回値と比較してメッセージを作成
      strLstDiffMsg = '';
      for (j = 0; j < constants.NOWDISEASE_COUNT; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 23 + i * 3].result
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 23 + i * 3].result !== '') {
          // 同じ病名を検索
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 23 + i * 3].result === ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 23 + j * 3].lstresult) {
            // 年齢が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 24 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 24 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '年齢';
            }
            // 治療状態が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 25 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 25 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '治療状態';
            }
          }
        }
      }

      strLstRsl = '';
      for (j = 0; j < strArrCode1.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 23 + i * 3].lstresult === strArrCode1[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName1[j];
          break;
        }
      }
      strLstRsl += (strLstRsl === '' ? '' : ' ');
      strLstRsl += (!ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 24 + i * 3].lstresult
        || ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 24 + i * 3].lstresult === '' ? '' : `${ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 24 + i * 3].lstresult}才`);
      for (j = 0; j < strArrCode2.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 25 + i * 3].lstresult === strArrCode2[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName2[j];
          break;
        }
      }

      strDisease.push((
        <div key={`DISEASEHIST_${i}`}>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: '45px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 23 + i * 3, 'disease', `${i + constants.NOWDISEASE_COUNT}`, 3, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '405px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 23 + i * 3, 'list1', `list1_2_1[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 24 + i * 3, 'text', `Rsl[${constants.OCRGRP_START1 + 24 + i * 3}]`, 3, '')}才
          </div>
          <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 25 + i * 3, 'list2', `list1_2_2[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '164px', marginTop: '2px', marginLeft: '2px' }}>
            {strLstDiffMsg !== '' && <span style={{ color: 'red', fontWeight: 'bold', fontSize: '15px' }}>※{ strLstDiffMsg }違い</span>}
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '2px', marginLeft: '300px' }}>
            {strLstRsl}
          </div>
          <div style={{ clear: 'left' }} />
        </div>
      ));
    }
    return strDisease;
  }

  // 家族歴 １－c．
  getDisease1cArea = () => {
    const { ocrNyuryoku } = this.props;
    const strDisease = [];
    let i;
    let j;
    let strLstDiffMsg;
    let strLstRsl;

    for (i = 0; i < constants.FAMILYHIST_COUNT; i += 1) {
      // 前回値と比較してメッセージを作成
      strLstDiffMsg = '';
      for (j = 0; j < constants.NOWDISEASE_COUNT; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 41 + i * 3].result
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 41 + i * 3].result !== '') {
          // 同じ病名を検索
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 41 + i * 3].result === ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 41 + j * 3].lstresult) {
            // 発症年齢が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 42 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 42 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '発症年齢';
            }
            // 続柄が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 43 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 43 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '続柄';
            }
          }
        }
      }

      strLstRsl = '';
      for (j = 0; j < strArrCode1.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 41 + i * 3].lstresult === strArrCode1[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName1[j];
          break;
        }
      }
      strLstRsl += (strLstRsl === '' ? '' : ' ');
      strLstRsl += (!ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 42 + i * 3].lstresult
        || ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 42 + i * 3].lstresult === '' ? '' : `${ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 42 + i * 3].lstresult}才`);
      for (j = 0; j < strArrCode3.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 43 + i * 3].lstresult === strArrCode3[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName3[j];
          break;
        }
      }

      strDisease.push((
        <div key={`FAMILYHIST_${i}`}>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: '45px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 41 + i * 3, 'disease', `${i + constants.DISEASEHIST_COUNT}`, 3, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '405px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 41 + i * 3, 'list1', `list1_3_1[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 42 + i * 3, 'text', `Rsl[${constants.OCRGRP_START1 + 42 + i * 3}]`, 3, '')}才
          </div>
          <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 43 + i * 3, 'list3', `list1_3_2[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '164px', marginTop: '2px', marginLeft: '2px' }}>
            {strLstDiffMsg !== '' && <span style={{ color: 'red', fontWeight: 'bold', fontSize: '15px' }}>※{ strLstDiffMsg }違い</span>}
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '2px', marginLeft: '300px' }}>
            {strLstRsl}
          </div>
          <div style={{ clear: 'left' }} />
        </div>
      ));
    }
    return strDisease;
  }

  getChecked = (vntIndex, vntOnValue) => {
    const { chgRsl } = this.props;
    const value = (chgRsl && chgRsl[vntIndex]) ? chgRsl[vntIndex].result : null;
    return value === vntOnValue;
  }

  setChgRsl = (index, result) => {
    const { chgRsl, ocrNyuryoku } = this.props;

    chgRsl[index] = {
      itemcd: ocrNyuryoku.ocrresult[index].itemcd,
      suffix: ocrNyuryoku.ocrresult[index].suffix,
      result,
      lstresult: ocrNyuryoku.ocrresult[index].lstresult,
      stopflg: ocrNyuryoku.ocrresult[index].stopflg,
    };
  }

  editRslEvent = (e, vntIndex) => {
    if (vntIndex < constants.OCRGRP_START4 + 75 || vntIndex > constants.OCRGRP_START4 + 84) {
      this.setChgRsl(vntIndex, e.target.value);
    } else {
      let date;
      let year;
      let month;
      let day;

      if (Object.values(e).length < 10) {
        date = '';
        year = '';
        month = '';
        day = '';
      } else {
        date = Object.values(e).slice(0, 10).join('');
        year = moment(date).year();
        month = moment(date).month() + 1;
        day = moment(date).date();
      }

      if (vntIndex === constants.OCRGRP_START4 + 75 || vntIndex === constants.OCRGRP_START4 + 80) {
        this.setChgRsl(vntIndex, year);
        this.setChgRsl(vntIndex + 1, month);
        this.setChgRsl(vntIndex + 2, day);
      } else if (vntIndex === constants.OCRGRP_START4 + 78 || vntIndex === constants.OCRGRP_START4 + 83) {
        this.setChgRsl(vntIndex, month);
        this.setChgRsl(vntIndex + 1, day);
      }
    }
  }

  // 検査結果の選択時処理
  clickRsl = (e, Index) => {
    const { chgRsl, setValue } = this.props;
    // 婦人科問診票のNo.4、13、15の「なし」のチェックが他の項目を選択した時に自動的に消える
    let lngIndex = 0;
    const modChgRsl = [];
    // エレメントタイプごとの処理分岐
    switch (e.target.type) {
      // チェックボックス
      case 'checkbox':
        if (e.target.checked) {
          this.setChgRsl(Index, e.target.value);
          // 婦人科問診票のNo.7の「なし」のチェックが他の項目を選択した時に自動的に消える
          lngIndex = constants.OCRGRP_START4;
          if (Index >= lngIndex + 19 && Index <= lngIndex + 33) {
            this.setChgRsl(194, '');
          }
        } else {
          this.setChgRsl(Index, '');
        }
        for (let i = 0; i < chgRsl.length; i += 1) {
          modChgRsl[i] = chgRsl[i];
        }
        setValue('chgRsl', modChgRsl);
        break;
      // ラジオボタン
      case 'radio':
        // 選択済みをもう一度クリックすると選択解除
        if (chgRsl[Index] && chgRsl[Index].result === e.target.value) {
          // e.target.checked = false;
          setValue(e.target.name, '');
          this.setChgRsl(Index, '');
        } else {
          // e.target.checked = true;
          this.setChgRsl(Index, e.target.value);
        }
        break;
      default: break;
    }
  }

  // エラー情報のタグ生成
  editErrInfo = () => {
    let strAnchor = '';

    errInfoNo += 1;
    strAnchor = `Anchor-ErrInfo${errInfoNo}`;

    return <span id={strAnchor} style={{ position: 'relative' }} />;
  }

  // 自覚症状表示
  editJikakushoujyou = (lngStartIndex) => {
    const { ocrNyuryoku } = this.props;
    const strJikakushoujyou = [];
    let i;
    let j;
    let strLstRsl;
    const items1 = [];
    const items2 = [];
    const items3 = [];
    const items4 = [];
    for (i = 0; i < strArrCodeJikaku1.length; i += 1) {
      items1.push({ value: strArrCodeJikaku1[i], name: strArrNameJikaku1[i] });
    }
    for (i = 0; i < strArrCodeJikaku2.length; i += 1) {
      items2.push({ value: strArrCodeJikaku2[i], name: strArrNameJikaku2[i] });
    }
    for (i = 0; i < strArrCodeJikaku3.length; i += 1) {
      items3.push({ value: strArrCodeJikaku3[i], name: strArrNameJikaku3[i] });
    }
    for (i = 0; i < strArrCodeJikaku4.length; i += 1) {
      items4.push({ value: strArrCodeJikaku4[i], name: strArrNameJikaku4[i] });
    }
    strJikakushoujyou.push((
      <div key="JIKAKUSHOUJYOU_HEAD">
        <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
        <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
          <div style={{ float: 'left', backgroundColor: '#eeeeee', width: '180px' }}><span>自覚症状内容</span></div>
          <div style={{ float: 'left', backgroundColor: '#eeeeee', width: '50px', marginLeft: '2px' }}><span>数値</span></div>
          <div style={{ float: 'left', backgroundColor: '#eeeeee', width: '80px', marginLeft: '2px' }}><span>単位</span></div>
          <div style={{ float: 'left', backgroundColor: '#eeeeee', width: '80px', marginLeft: '2px' }}><span>受診</span></div>
        </div>
        <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
        <div style={{ clear: 'left' }} />
      </div>
    ));

    for (i = 0; i < constants.JIKAKUSHOUJYOU_COUNT; i += 1) {
      strLstRsl = '';
      for (j = 0; j < strArrCodeJikaku1.length; j += 1) {
        if (ocrNyuryoku.ocrresult[lngStartIndex + i * 4].lstresult === strArrCodeJikaku1[j]) {
          strLstRsl += (strLstRsl === '' ? '' : '　');
          strLstRsl += strArrNameJikaku1[j];
          break;
        }
      }
      if (ocrNyuryoku.ocrresult[lngStartIndex + 1 + i * 4].lstresult
        && ocrNyuryoku.ocrresult[lngStartIndex + 1 + i * 4].lstresult !== '') {
        strLstRsl += (strLstRsl === '' ? '' : '　');
        strLstRsl += ocrNyuryoku.ocrresult[lngStartIndex + 1 + i * 4].lstresult;
      }
      for (j = 0; j < strArrCodeJikaku3.length; j += 1) {
        if (ocrNyuryoku.ocrresult[lngStartIndex + 2 + i * 4].lstresult === strArrCodeJikaku3[j]) {
          strLstRsl += (strLstRsl === '' ? '' : '　');
          strLstRsl += strArrNameJikaku3[j];
          break;
        }
      }
      for (j = 0; j < strArrCodeJikaku4.length; j += 1) {
        if (ocrNyuryoku.ocrresult[lngStartIndex + 3 + i * 4].lstresult === strArrCodeJikaku4[j]) {
          strLstRsl += (strLstRsl === '' ? '' : '　');
          strLstRsl += strArrNameJikaku4[j];
          break;
        }
      }

      const index = lngStartIndex + i * 4;
      strJikakushoujyou.push((
        <div key={`JIKAKUSHOUJYOU_${i}`}>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <Field name={`listjikaku1[${i + 1}]`} component={DropDown} items={items1} addblank onChange={(e) => this.editRslEvent(e, index + 0)} />
            </div>
            <div style={{ float: 'left', height: '28px', width: '50px', marginTop: '2px', marginLeft: '2px' }}>
              <Field name={`listjikaku2[${i + 1}]`} component={DropDown} items={items2} addblank onChange={(e) => this.editRslEvent(e, index + 1)} />
            </div>
            <div style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', marginLeft: '2px' }}>
              <Field name={`listjikaku3[${i + 1}]`} component={DropDown} items={items3} addblank onChange={(e) => this.editRslEvent(e, index + 2)} />
            </div>
            <div style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', marginLeft: '2px' }}>
              <Field name={`listjikaku4[${i + 1}]`} component={DropDown} items={items4} addblank onChange={(e) => this.editRslEvent(e, index + 3)} />
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '2px', marginLeft: '2px' }}>
            {strLstRsl}
          </div>
          <div style={{ clear: 'left' }} />
        </div>
      ));
    }
    return strJikakushoujyou;
  }

  // 検査結果のタグ生成
  editRsl = (vntIndex, vntType, vntName, vntSize, vntOnValue) => {
    const { ocrNyuryoku, chgRsl } = this.props;
    const items = [];

    let blnSearchFlg;
    let i;

    switch (vntType) {
      // テキスト
      case 'text':
        return (
          <Field
            component={TextBox}
            name={vntName}
            size={vntSize}
            maxLength="8"
            style={{ textAlign: 'right', width: '50px' }}
            onChange={(e) => this.editRslEvent(e, vntIndex)}
          />
        );
      // チェックボックス
      case 'checkbox':
        if (!chgRsl || chgRsl.length === 0) {
          return null;
        }
        return (
          <input type="checkbox" name={vntName} value={vntOnValue} checked={this.getChecked(vntIndex, vntOnValue)} onChange={(e) => this.clickRsl(e, vntIndex)} />
        );
      // ラジオボタン
      case 'radio':
        return (
          <Field component="input" type="radio" name={vntName} value={vntOnValue} onClick={(e) => this.clickRsl(e, vntIndex)} />
        );
      // ドロップダウンリスト（病名）
      case 'list1':
        if (!ocrNyuryoku || !ocrNyuryoku.ocrresult || ocrNyuryoku.ocrresult.length === 0) {
          return null;
        }
        // 文章コードのチェック
        if (!ocrNyuryoku.ocrresult[vntIndex].result || ocrNyuryoku.ocrresult[vntIndex].result === '') {
          blnSearchFlg = true;
        } else {
          for (i = 0; i < strArrCode1.length; i += 1) {
            if (ocrNyuryoku.ocrresult[vntIndex].result === strArrCode1[i]) {
              blnSearchFlg = true;
              break;
            }
          }
        }
        // 選択肢以外の場合は値を無効とする
        if (!blnSearchFlg) {
          ocrNyuryoku.ocrresult[vntIndex].result = 'XXX';
        }

        for (i = 0; i < strArrCode1.length; i += 1) {
          items.push({ value: strArrCode1[i], name: strArrName1[i] });
        }
        return (
          <Field name={vntName} component={DropDown} items={items} addblank onChange={(e) => this.editRslEvent(e, vntIndex)} />
        );
      // 病名選択用テキスト
      case 'disease':
        return (
          <Field
            name={`disease[${vntName}]`}
            size={vntSize}
            maxLength="3"
            style={{ textAlign: 'right', width: '40px' }}
            component={TextBox}
            onChange={(e) => this.selectDiseaseList(e, vntIndex, vntName)}
          />
        );
      // ドロップダウンリスト（治療状況）
      case 'list2':
        if (!ocrNyuryoku || !ocrNyuryoku.ocrresult || ocrNyuryoku.ocrresult.length === 0) {
          return null;
        }
        // 文章コードのチェック
        if (!ocrNyuryoku.ocrresult[vntIndex].result || ocrNyuryoku.ocrresult[vntIndex].result === '') {
          blnSearchFlg = true;
        } else {
          for (i = 0; i < strArrCode2.length; i += 1) {
            if (ocrNyuryoku.ocrresult[vntIndex].result === strArrCode2[i]) {
              blnSearchFlg = true;
              break;
            }
          }
        }
        // 選択肢以外の場合は値を無効とする
        if (!blnSearchFlg) {
          ocrNyuryoku.ocrresult[vntIndex].result = 'XXX';
        }

        for (i = 0; i < strArrCode2.length; i += 1) {
          items.push({ value: strArrCode2[i], name: strArrName2[i] });
        }
        return (
          <Field name={vntName} component={DropDown} items={items} addblank onChange={(e) => this.editRslEvent(e, vntIndex)} />
        );
      // ドロップダウンリスト（治療状況）
      case 'list3':
        if (!ocrNyuryoku || !ocrNyuryoku.ocrresult || ocrNyuryoku.ocrresult.length === 0) {
          return null;
        }
        // 文章コードのチェック
        if (!ocrNyuryoku.ocrresult[vntIndex].result || ocrNyuryoku.ocrresult[vntIndex].result === '') {
          blnSearchFlg = true;
        } else {
          for (i = 0; i < strArrCode3.length; i += 1) {
            if (ocrNyuryoku.ocrresult[vntIndex].result === strArrCode3[i]) {
              blnSearchFlg = true;
              break;
            }
          }
        }
        // 選択肢以外の場合は値を無効とする
        if (!blnSearchFlg) {
          ocrNyuryoku.ocrresult[vntIndex].result = 'XXX';
        }

        for (i = 0; i < strArrCode3.length; i += 1) {
          items.push({ value: strArrCode3[i], name: strArrName3[i] });
        }
        return (
          <Field name={vntName} component={DropDown} items={items} addblank onChange={(e) => this.editRslEvent(e, vntIndex)} />
        );
      // （年月日）
      case 'listdate':
        if (!ocrNyuryoku || !ocrNyuryoku.ocrresult || ocrNyuryoku.ocrresult.length === 0) {
          return null;
        }
        return (
          <Field name={vntName} component={DatePicker} onChange={(e) => this.editRslEvent(e, vntIndex)} />
        );
      default: return null;
    }
  }

  // 病名の選択処理
  selectDiseaseList = (e, vntIndex, vntName) => {
    const { setValue } = this.props;
    const { value } = e.target;
    if (strArrCode1.findIndex((v) => (v === value)) > -1) {
      setValue(vntName, value);
      this.setChgRsl(vntIndex, value);
    } else {
      setValue(vntName, strArrCode1[strArrCode1.length - 1]);
      this.setChgRsl(vntIndex, strArrCode1[strArrCode1.length - 1]);
    }
  }

  // 献立の編集
  editMenuList = (vntIndex) => {
    let color = '';
    let fristtext = '';
    if (vntIndex) {
      switch (vntIndex) {
        case constants.OCRGRP_START6:
          color = 'ffe4b5';
          fristtext = '朝';
          break;
        case constants.OCRGRP_START7:
          color = 'f0e68c';
          fristtext = '昼';
          break;
        case constants.OCRGRP_START8:
          color = 'add8e6';
          fristtext = '夕';
          break;
        default: break;
      }
    }

    const strMenuList = [];
    strMenuList.push((
      <div>
        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '40px', marginTop: '2px' }} />
        <div div style={{ float: 'left', height: '22px', width: `${nowDivEditHeadWidth}px` }}>
          <span style={{ float: 'left', height: '20px', width: '335px', marginTop: '2px' }}>主食 </span>
          <span style={{ float: 'left', height: '20px', width: '413px', marginTop: '2px' }}>主菜 </span>
          <span style={{ float: 'left', height: '20px', width: '320px', marginTop: '2px' }}>副菜 </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '28px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eeeeee', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eeeeee', marginLeft: '2px' }}>ご飯（女性用茶碗） </span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eeeeee', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 1, 'text', `Rsl[${vntIndex + 1}]`, 2, '')}杯
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>刺身盛り合わせ </span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 32, 'text', `Rsl[${vntIndex + 32}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>野菜サラダ </span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 63, 'text', `Rsl[${vntIndex + 63}]`, 2, '')}皿
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '28px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eeeeee', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eeeeee', marginLeft: '2px' }}>ご飯（男性用茶碗）</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eeeeee', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 2, 'text', `Rsl[${vntIndex + 2}]`, 2, '')}杯
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>煮魚・焼魚（ぶり、さんま、いわし等）</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 33, 'text', `Rsl[${vntIndex + 33}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>　ノンオイルドレッシング</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 64, 'text', `Rsl[${vntIndex + 64}]`, 2, '')}杯
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '28px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '45px', width: '50px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '-14px' }}>米</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eeeeee', marginLeft: '2px' }}>ご飯（どんぶり茶碗）</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eeeeee', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 3, 'text', `Rsl[${vntIndex + 3}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '30px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>煮魚・焼魚（かれい、たら、ひらめ等）</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 34, 'text', `Rsl[${vntIndex + 34}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>　マヨネーズ</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 65, 'text', `Rsl[${vntIndex + 65}]`, 2, '')}杯
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '28px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '28px', width: '50px', backgroundColor: '#eeeeee', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eeeeee', marginLeft: '2px' }}>おにぎり</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eeeeee', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 4, 'text', `Rsl[${vntIndex + 4}]`, 2, '')}個</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '50px', width: '50px', backgroundColor: '#e0ffff', marginLeft: '2px', marginTop: '-14px' }} >魚</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>魚のムニエル</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 35, 'text', `Rsl[${vntIndex + 35}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>　ドレッシング</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 66, 'text', `Rsl[${vntIndex + 66}]`, 2, '')}杯
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>そば・うどん（天ぷら）</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 5, 'text', `Rsl[${vntIndex + 5}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>エビチリ</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 36, 'text', `Rsl[${vntIndex + 36}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>　塩</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 67, 'text', `Rsl[${vntIndex + 67}]`, 2, '')}つまみ
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>そば・うどん（たぬき）</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 6, 'text', `Rsl[${vntIndex + 6}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '26px' }} />
          <span style={{ float: 'left', height: '28px', width: '50px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>八宝菜</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e0ffff', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 37, 'text', `Rsl[${vntIndex + 37}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>ポテト・マカロニサラダ</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 68, 'text', `Rsl[${vntIndex + 68}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>そば・うどん（ざる・かけ）</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 7, 'text', `Rsl[${vntIndex + 7}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '30px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>ステーキ(150g)</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 38, 'text', `Rsl[${vntIndex + 38}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>野菜料理</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>煮物（芋入り）</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 69, 'text', `Rsl[${vntIndex + 69}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>ラーメン</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 8, 'text', `Rsl[${vntIndex + 8}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '30px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>焼き肉</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 39, 'text', `Rsl[${vntIndex + 39}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>煮物（野菜のみ）</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 70, 'text', `Rsl[${vntIndex + 70}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>めん</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>五目ラーメン</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 9, 'text', `Rsl[${vntIndex + 9}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '30px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>とりの唐揚</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 40, 'text', `Rsl[${vntIndex + 40}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>煮物（ひじき・昆布等）</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 71, 'text', `Rsl[${vntIndex + 71}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>焼きそば</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 10, 'text', `Rsl[${vntIndex + 10}]`, 2, '')}皿</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>ハンバーグ</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 41, 'text', `Rsl[${vntIndex + 41}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>肉じゃが</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 72, 'text', `Rsl[${vntIndex + 72}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>スパゲッティ（クリーム）</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 11, 'text', `Rsl[${vntIndex + 11}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>肉</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>シチュー</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 42, 'text', `Rsl[${vntIndex + 42}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>野菜炒め（肉なし）</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 73, 'text', `Rsl[${vntIndex + 73}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>スパゲッティ（その他）</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 12, 'text', `Rsl[${vntIndex + 12}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>肉野菜炒め</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 43, 'text', `Rsl[${vntIndex + 43}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>おひたし</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 74, 'text', `Rsl[${vntIndex + 74}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '28px', width: '50px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>マカロニグラタン</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 13, 'text', `Rsl[${vntIndex + 13}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>餃子・シュウマイ</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 44, 'text', `Rsl[${vntIndex + 44}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '28px', width: '70px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>酢の物</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#98fb98', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 75, 'text', `Rsl[${vntIndex + 75}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f5deb3', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>食パン６枚切り</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 14, 'text', `Rsl[${vntIndex + 14}]`, 2, '')}枚</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '30px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>ハム・ウィンナー</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 45, 'text', `Rsl[${vntIndex + 45}]`, 2, '')}枚
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }}>味噌汁</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 76, 'text', `Rsl[${vntIndex + 76}]`, 2, '')}杯
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f5deb3', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>食パン８枚切り</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 15, 'text', `Rsl[${vntIndex + 15}]`, 2, '')}枚</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '28px', width: '50px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>ベーコン</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 46, 'text', `Rsl[${vntIndex + 46}]`, 2, '')}枚
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }}>汁</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }}>コンソメ</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 77, 'text', `Rsl[${vntIndex + 77}]`, 2, '')}杯
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }}>{fristtext}</span>
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f5deb3', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>　バター</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 16, 'text', `Rsl[${vntIndex + 16}]`, 2, '')}枚</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>フライ（コロッケ）</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 47, 'text', `Rsl[${vntIndex + 47}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '28px', width: '70px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }}>ポタージュ</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#ffdead', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 78, 'text', `Rsl[${vntIndex + 78}]`, 2, '')}杯
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>パン</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>　マーガリン</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 17, 'text', `Rsl[${vntIndex + 17}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>フライ（トンカツ）</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 48, 'text', `Rsl[${vntIndex + 48}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>チーズ</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 79, 'text', `Rsl[${vntIndex + 79}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f5deb3', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>　ジャム類</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 18, 'text', `Rsl[${vntIndex + 18}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '50px', width: '50px', backgroundColor: '#f0e68c', marginLeft: '2px', marginTop: '-14px' }}>揚げ物</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>フライ（えび）</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 49, 'text', `Rsl[${vntIndex + 49}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '30px', width: '70px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>枝豆</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 80, 'text', `Rsl[${vntIndex + 80}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f5deb3', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>ミックスサンドイッチ</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 19, 'text', `Rsl[${vntIndex + 19}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '28px', width: '50px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>天ぷら</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 50, 'text', `Rsl[${vntIndex + 50}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '50px', width: '70px', backgroundColor: '#fffacd', marginLeft: '2px', marginTop: '-14px' }}>もう一品</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>果物</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 81, 'text', `Rsl[${vntIndex + 81}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f5deb3', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>菓子パン</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 20, 'text', `Rsl[${vntIndex + 20}]`, 2, '')}個</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>すき焼き・しゃぶしゃぶ等</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 51, 'text', `Rsl[${vntIndex + 51}]`, 2, '')}人前
          </span>
          <span style={{ float: 'left', width: '17px', height: '22px' }} />
          <span style={{ float: 'left', height: '28px', width: '70px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '170px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>お漬物</span>
          <span style={{ float: 'left', height: '28px', width: '90px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 82, 'text', `Rsl[${vntIndex + 82}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '28px', width: '50px', backgroundColor: '#f5deb3', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>調理パン</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f5deb3', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 21, 'text', `Rsl[${vntIndex + 21}]`, 2, '')}個</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>鍋</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>寄鍋・たらちり等</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 52, 'text', `Rsl[${vntIndex + 52}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>カツ丼</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 22, 'text', `Rsl[${vntIndex + 22}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '28px', width: '50px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>おでん</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#eee8aa', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 53, 'text', `Rsl[${vntIndex + 53}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>親子丼</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 23, 'text', `Rsl[${vntIndex + 23}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>生卵・ゆで卵</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 54, 'text', `Rsl[${vntIndex + 54}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>天丼</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 24, 'text', `Rsl[${vntIndex + 24}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>目玉焼き</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 55, 'text', `Rsl[${vntIndex + 55}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>丼物</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>中華丼</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 25, 'text', `Rsl[${vntIndex + 25}]`, 2, '')}杯</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>卵</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>卵焼き</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 56, 'text', `Rsl[${vntIndex + 56}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>カレーライス</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 26, 'text', `Rsl[${vntIndex + 26}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>スクランブル</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 57, 'text', `Rsl[${vntIndex + 57}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>チャーハン・ピラフ</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 27, 'text', `Rsl[${vntIndex + 27}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '28px', width: '50px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>かに玉</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#fffacd', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 58, 'text', `Rsl[${vntIndex + 58}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '28px', width: '50px', backgroundColor: '#f0e68c', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>にぎり・ちらし寿司</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#f0e68c', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 28, 'text', `Rsl[${vntIndex + 28}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '30px', width: '50px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }}>冷・湯豆腐</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 59, 'text', `Rsl[${vntIndex + 59}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>幕の内弁当</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 29, 'text', `Rsl[${vntIndex + 29}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '28px', width: '50px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }}>納豆</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 60, 'text', `Rsl[${vntIndex + 60}]`, 2, '')}個
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '30px', width: '20px', backgroundColor: `#${color}` }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '30px', width: '50px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>その他</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>シリアル等</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 30, 'text', `Rsl[${vntIndex + 30}]`, 2, '')}皿</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <div style={{ float: 'left', textAlign: 'center' }}>
            <span style={{ float: 'left', height: '50px', width: '50px', backgroundColor: '#e6e6fa', marginLeft: '2px', marginTop: '-14px' }}>豆製品</span>
          </div>
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }}>マーボ豆腐</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 61, 'text', `Rsl[${vntIndex + 61}]`, 2, '')}人前
          </span>
        </div>

        <div style={{ clear: 'left' }} />
        <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
        <div style={{ float: 'left', height: '24px', width: `${nowDivEditWidth}px`, marginTop: '2px' }}>
          <span style={{ float: 'left', height: '28px', width: '20px', backgroundColor: `#${color}` }} />
          <span style={{ float: 'left', height: '28px', width: '50px', backgroundColor: '#ffc0cb', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '190px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>ミックスピザ</span>
          <span style={{ float: 'left', height: '28px', width: '70px', backgroundColor: '#ffc0cb', marginLeft: '2px' }}>
            <div style={{ borderRadius: '10px' }}>{this.editRsl(vntIndex + 31, 'text', `Rsl[${vntIndex + 31}]`, 2, '')}人前</div>
          </span>
          <span style={{ float: 'left', width: '17px', height: '28px' }} />
          <span style={{ float: 'left', height: '28px', width: '50px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }} />
          <span style={{ float: 'left', height: '28px', width: '260px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }}>五目豆</span>
          <span style={{ float: 'left', height: '28px', width: '80px', marginTop: '2px', backgroundColor: '#e6e6fa', marginLeft: '2px' }}>
            {this.editRsl(vntIndex + 62, 'text', `Rsl[${vntIndex + 62}]`, 2, '')}人前
          </span>
        </div>
      </div>
    ));
    return strMenuList;
  }

  // 保存
  save = (act) => {
    const { rsvno, onSave, chgRsl, consult } = this.props;
    const { gender = 0 } = consult;
    let count;
    let index;
    const buff = [];
    let i;
    let j;
    if (gender === 2) {
      index = constants.OCRGRP_START4;
      // chgRsl[index + 75].result = myForm.year14_1.value;
      // chgRsl[index + 76].result = myForm.month14_1.value;
      // chgRsl[index + 77].result = myForm.day14_1.value;
      // chgRsl[index + 78].result = myForm.month14_2.value;
      // chgRsl[index + 79].result = myForm.day14_2.value;
      // chgRsl[index + 80].result = myForm.year14_3.value;
      // chgRsl[index + 81].result = myForm.month14_3.value;
      // chgRsl[index + 82].result = myForm.day14_3.value;
      // chgRsl[index + 83].result = myForm.month14_4.value;
      // chgRsl[index + 84].result = myForm.day14_4.value;
    }

    // ********
    // 前詰め
    // ********
    // 現病歴
    index = constants.OCRGRP_START1 + 5;
    count = 0;
    for (i = 0; i < constants.NOWDISEASE_COUNT; i += 1) {
      if ((chgRsl[index + i * 3 + 0].result && chgRsl[index + i * 3 + 0].result !== '')
        || (chgRsl[index + i * 3 + 1].result && chgRsl[index + i * 3 + 1].result !== '')
        || (chgRsl[index + i * 3 + 2].result && chgRsl[index + i * 3 + 2].result !== '')) {
        for (j = 0; j < 3; j += 1) {
          buff[count * 3 + j] = chgRsl[index + i * 3 + j].result;
        }
        count += 1;
      }
    }
    for (i = 0; i < constants.NOWDISEASE_COUNT; i += 1) {
      if (i < count) {
        for (j = 0; j < 3; j += 1) {
          chgRsl[index + i * 3 + j].result = buff[i * 3 + j];
        }
      } else {
        for (j = 0; j < 3; j += 1) {
          chgRsl[index + i * 3 + j].result = '';
        }
      }
    }

    // 既往歴
    index = constants.OCRGRP_START1 + 23;
    count = 0;
    for (i = 0; i < constants.DISEASEHIST_COUNT; i += 1) {
      if ((chgRsl[index + i * 3 + 0].result && chgRsl[index + i * 3 + 0].result !== '')
        || (chgRsl[index + i * 3 + 1].result && chgRsl[index + i * 3 + 1].result !== '')
        || (chgRsl[index + i * 3 + 2].result && chgRsl[index + i * 3 + 2].result !== '')) {
        for (j = 0; j < 3; j += 1) {
          buff[count * 3 + j] = chgRsl[index + i * 3 + j].result;
        }
        count += 1;
      }
    }
    for (i = 0; i < constants.DISEASEHIST_COUNT; i += 1) {
      if (i < count) {
        for (j = 0; j < 3; j += 1) {
          chgRsl[index + i * 3 + j].result = buff[i * 3 + j];
        }
      } else {
        for (j = 0; j < 3; j += 1) {
          chgRsl[index + i * 3 + j].result = '';
        }
      }
    }

    // 家族歴
    index = constants.OCRGRP_START1 + 41;
    count = 0;
    for (i = 0; i < constants.FAMILYHIST_COUNT; i += 1) {
      if ((chgRsl[index + i * 3 + 0].result && chgRsl[index + i * 3 + 0].result !== '')
        || (chgRsl[index + i * 3 + 1].result && chgRsl[index + i * 3 + 1].result !== '')
        || (chgRsl[index + i * 3 + 2].result && chgRsl[index + i * 3 + 2].result !== '')) {
        for (j = 0; j < 3; j += 1) {
          buff[count * 3 + j] = chgRsl[index + i * 3 + j].result;
        }
        count += 1;
      }
    }
    for (i = 0; i < constants.FAMILYHIST_COUNT; i += 1) {
      if (i < count) {
        for (j = 0; j < 3; j += 1) {
          chgRsl[index + i * 3 + j].result = buff[i * 3 + j];
        }
      } else {
        for (j = 0; j < 3; j += 1) {
          chgRsl[index + i * 3 + j].result = '';
        }
      }
    }

    // 自覚症状
    index = constants.OCRGRP_START2 + 37;
    count = 0;
    for (i = 0; i < constants.JIKAKUSHOUJYOU_COUNT; i += 1) {
      if ((chgRsl[index + i * 4 + 0].result && chgRsl[index + i * 4 + 0].result !== '')
        || (chgRsl[index + i * 4 + 1].result && chgRsl[index + i * 4 + 1].result !== '')
        || (chgRsl[index + i * 4 + 2].result && chgRsl[index + i * 4 + 2].result !== '')
        || (chgRsl[index + i * 4 + 3].result && chgRsl[index + i * 4 + 3].result !== '')) {
        for (j = 0; j < 4; j += 1) {
          buff[count * 4 + j] = chgRsl[index + i * 4 + j].result;
        }
        count += 1;
      }
    }
    for (i = 0; i < constants.JIKAKUSHOUJYOU_COUNT; i += 1) {
      if (i < count) {
        for (j = 0; j < 4; j += 1) {
          chgRsl[index + i * 4 + j].result = buff[i * 4 + j];
        }
      } else {
        for (j = 0; j < 4; j += 1) {
          chgRsl[index + i * 4 + j].result = '';
        }
      }
    }

    onSave({ rsvno, formName, act, chgRsl });
  }

  // 前回複写
  copyOcrNyuryoku = () => {
    const { chgRsl, setValue } = this.props;

    let i;
    let j;
    let n;
    let idxChgRsl;
    let idxPreRsl;
    // 病歴データ配列のインデックス
    let index;
    // 前回値の件数
    let cntPreByoureki;
    // 今回入力欄の件数
    let cntInputedByoreki;
    // 今回入力欄の病歴件数が6件かどうかフラグ
    let isOver;
    // 現病歴、既往歴、過去歴の登録できる病歴の最大数
    let cntByoreki = [];
    // 現病歴、既往歴、過去歴のインデックス
    let idxChgRsls = [];
    // 現病歴、既往歴、過去歴のエラー行番号
    let arErrNo = [];
    // 現病歴、既往歴、過去歴のエラーメッセージ
    let arErrMsg;
    // 前回値配列の複写済みの病歴インデックス
    let arCopyByorekiIdx;
    // 複写済み病歴コード
    let arCopyByorekiCd;

    let strHtml;

    let errNoEx = [];
    let name;
    let idName;

    // 病歴数最大値
    cntByoreki = [constants.NOWDISEASE_COUNT, constants.DISEASEHIST_COUNT, constants.FAMILYHIST_COUNT];
    // 病歴データ配列のインデックス
    idxChgRsls = [constants.OCRGRP_START1 + 5, constants.OCRGRP_START1 + 23, constants.OCRGRP_START1 + 41];
    // エラー行番号
    arErrNo = [4, 10, 16];
    // エラーメッセージ
    arErrMsg = ['「現病歴」は6件より多く登録できません。', '「既往歴」は6件より多く登録できません。', '「家族歴」は6件より多く登録できません。'];

    for (n = 0; n < cntByoreki.length; n += 1) {
      // 病歴数オーバーの警告メッセージがあればを削除
      // parent.delErrInfo(arErrNo[n], iconNo, arErrMsg[n]);
      document.getElementById(`Anchor-ErrInfo${arErrNo[n]}`).innerHTML = '';

      // 処理用変数を初期化
      index = idxChgRsls[n];
      isOver = false;
      cntInputedByoreki = 0;
      cntPreByoureki = 0;
      arCopyByorekiIdx = [];
      arCopyByorekiCd = [];

      // 前回値の件数を取得
      for (i = 0; i < cntByoreki[n]; i += 1) {
        if (chgRsl[index + i * 3 + 0].lstresult && chgRsl[index + i * 3 + 0].lstresult !== '') {
          cntPreByoureki += 1;
        }
      }

      // -----------------------------------------------------------------
      // 入力チェック
      // ・前回値が0件
      //   →何もする必要なし
      // ・前回値が1件以上
      //   →ひとつずつチェックして、複写
      // -----------------------------------------------------------------
      if (cntPreByoureki < 1) {
        // 何もする必要ない
      } else {
        // 今回入力欄 + 前回値 = 12回ループ
        for (idxChgRsl = 0; idxChgRsl < cntByoreki[n] * 2; idxChgRsl += 1) {
          // 今回入力欄が入力されているか判定
          if ((idxChgRsl < 6) &&
            ((chgRsl[index + idxChgRsl * 3 + 0].result && chgRsl[index + idxChgRsl * 3 + 0].result !== '') ||
              (chgRsl[index + idxChgRsl * 3 + 1].result && chgRsl[index + idxChgRsl * 3 + 1].result !== '') ||
              (chgRsl[index + idxChgRsl * 3 + 2].result && chgRsl[index + idxChgRsl * 3 + 2].result !== ''))) {
            // そのまま、病歴数をカウントアップ
            cntInputedByoreki += 1;
          } else {
            if (idxChgRsl < 6) {
              // ChgRslを初期化
              for (j = 0; j < 3; j += 1) {
                chgRsl[index + idxChgRsl * 3 + j].result = '';
              }
            }

            // 前回値の数分ループ
            for (idxPreRsl = 0; idxPreRsl < cntByoreki[n]; idxPreRsl += 1) {
              // 前回値の有無をチェック
              if (chgRsl[index + idxPreRsl * 3 + 0].lstresult !== '') {
                // 下記のいずれかなら複写対象となる
                // ・前回値が今回入力欄に存在しない 
                // ・すでに複写した前回値と同じ病歴
                if (((chgRsl[index + 0 * 3 + 0].result !== chgRsl[index + idxPreRsl * 3 + 0].lstresult) &&
                  (chgRsl[index + 1 * 3 + 0].result !== chgRsl[index + idxPreRsl * 3 + 0].lstresult) &&
                  (chgRsl[index + 2 * 3 + 0].result !== chgRsl[index + idxPreRsl * 3 + 0].lstresult) &&
                  (chgRsl[index + 3 * 3 + 0].result !== chgRsl[index + idxPreRsl * 3 + 0].lstresult) &&
                  (chgRsl[index + 4 * 3 + 0].result !== chgRsl[index + idxPreRsl * 3 + 0].lstresult) &&
                  (chgRsl[index + 5 * 3 + 0].result !== chgRsl[index + idxPreRsl * 3 + 0].lstresult)) ||
                  ((arCopyByorekiCd.length > 0) &&
                    (arCopyByorekiIdx[0] !== idxPreRsl) &&
                    (arCopyByorekiIdx[1] !== idxPreRsl) &&
                    (arCopyByorekiIdx[2] !== idxPreRsl) &&
                    (arCopyByorekiIdx[3] !== idxPreRsl) &&
                    (arCopyByorekiIdx[4] !== idxPreRsl) &&
                    (arCopyByorekiIdx[5] !== idxPreRsl) &&
                    (arCopyByorekiCd[0] === chgRsl[index + idxPreRsl * 3 + 0].lstresult ||
                      arCopyByorekiCd[1] === chgRsl[index + idxPreRsl * 3 + 0].lstresult ||
                      arCopyByorekiCd[2] === chgRsl[index + idxPreRsl * 3 + 0].lstresult ||
                      arCopyByorekiCd[3] === chgRsl[index + idxPreRsl * 3 + 0].lstresult ||
                      arCopyByorekiCd[4] === chgRsl[index + idxPreRsl * 3 + 0].lstresult ||
                      arCopyByorekiCd[5] === chgRsl[index + idxPreRsl * 3 + 0].lstresult))) {
                  // すでに病歴が6件登録されているか判定
                  if (cntInputedByoreki === 6) {
                    isOver = true;
                    // 画面下方のエラーメッセージスペースに表示
                    // parent.addErrInfo(arErrNo[n], iconNo, arErrMsg[n]);
                    // テキストボックスのすぐ横に警告アイコン表示
                    strHtml = `<div style="border: 2px orange solid; margin-right: 3px; height: 26px;"><span title=${arErrMsg[n]} style="color: orange; font-weight: bold;">I</span></div>`;
                    document.getElementById(`Anchor-ErrInfo${arErrNo[n]}`).innerHTML = strHtml;
                  } else {
                    // 複写処理
                    for (j = 0; j < 3; j += 1) {
                      // 内部変数ChgRslにコピー
                      chgRsl[index + idxChgRsl * 3 + j].result = chgRsl[index + idxPreRsl * 3 + j].lstresult;

                      if (j === 0) {
                        // 病名
                        setValue(`list1_${n + 1}_1[${cntInputedByoreki + 1}]`, chgRsl[index + idxChgRsl * 3 + j].lstresult);
                        // コントロールのフォントを赤字にする
                        // myForm['list1_' + (n + 1) + '_1' + (cntInputedByoreki + 1)].style.color = 'red';

                        // 複写した病歴を保持しておく ※インデックスも
                        arCopyByorekiIdx.push(idxPreRsl);
                        arCopyByorekiCd.push(chgRsl[index + idxPreRsl * 3 + j].lstresult);
                      } else if (j === 1) {
                        // 年齢
                        setValue(`Rsl[${index + idxChgRsl * 3 + j}]`, chgRsl[index + idxChgRsl * 3 + j].lstresult);
                        // document.getElementsByName('Rsl')[cntInputedByoreki + (6 * n)].value = chgRsl[index + idxChgRsl * 3 + j].result;
                      } else {
                        // 症状・続柄
                        setValue(`list1_${n + 1}_2[${index + idxChgRsl * 3 + j}]`, chgRsl[index + idxChgRsl * 3 + j].lstresult);
                        // setValue(`list1_${n + 1}_2${cntInputedByoreki + 1}`, chgRsl[index + idxChgRsl * 3 + j].result);
                      }
                    }
                    // 病歴コード欄を空白にする。
                    setValue(`disease[list1_${n + 1}_1]`, '');
                    // 病歴数をカウントアップ
                    cntInputedByoreki += 1;
                  }
                  // ループを抜ける
                  break;
                } else {
                  // すでにユーザが手入力で登録した病歴
                  // →何もしない
                }
              } else {
                // すでにユーザが手入力で登録した病歴
                // →何もしない
              }
            }
            // 病数オーバーなら、ループを抜ける
            if (isOver === true) break;
          }
        }
      }
    }

    // ２．胃検査を受ける方はお答え下さい
    // （１）手術をされた方へ
    // （２）ヘリコバクター・ピロリに関して
    errNoEx = 22;
    arErrMsg = ['「２－（１）手術をされた方へ 」は今回値が入力済みのため、前回値を複写しませんでした。',
      '「２－（２）ヘリコバクター・ピロリに関して 」は今回値が入力済みのため、前回値を複写しませんでした。'];
    index = constants.OCRGRP_START1 + 59;
    for (i = 0; i < 2; i += 1) {
      // 警告メッセージを初期化
      // parent.delErrInfo((errNoEx + i), iconNo, arErrMsg[i]);
      document.getElementById(`Anchor-ErrInfo${errNoEx + i}`).innerHTML = '';

      name = `opt1_4_${i + 1}`;
      // 今回入力欄が未チェック状態か判定
      if (chgRsl[i + index].result === '') {
        for (j = 0; j < document.getElementsByName(name).length; j += 1) {
          if (chgRsl[i + index].lstresult === document.getElementsByName(name)[j].value) {
            document.getElementsByName(name)[j].checked = true;
            chgRsl[i + index].result = chgRsl[i + index].lstresult;
            // ラベルカラーを赤にする
            document.getElementById(`STOMACH${i + 1}_${j + 1}`).style.color = 'red';
            break;
          }
        }
      } else if (chgRsl[i + index].lstresult === chgRsl[i + index].result) {
        // 今回値と前回値が同じ値
        // →何もしない
      } else if (chgRsl[i + index].lstresult !== '') {
        // 今回入力欄が入力済みかつ、前回値がある
        // →警告メッセージを表示
        // parent.addErrInfo((errNoEx + i), iconNo, arErrMsg[i]);
        // テキストボックスのすぐ横に警告アイコン表示
        strHtml = `<div style="border: 2px orange solid; margin-right: 3px; height: 26px;"><span title=${arErrMsg[i]} style="color: orange; font-weight: bold;">I</span></div>`;
        document.getElementById(`Anchor-ErrInfo${errNoEx + i}`).innerHTML = strHtml;
      }
    }

    // ３．以前他院で指摘を受けたものがあれば、ご記入下さい。
    index = constants.OCRGRP_START1 + 61;
    for (i = 0; i < 28; i += 1) {
      idName = '';

      // 前回値があり、今回入力欄が未チェック状態か判定
      if (chgRsl[i + index].lstresult !== '' &&
        chgRsl[i + index].result === '') {
        if (i < 7) {
          // （１）上部消化管検査
          name = `chk1_5_1_${i + 1}`;
          idName = `OTHER_HOSPITAL1_${i + 1}`;
        } else if (i < 18) {
          // （２）上腹部超音波検査
          name = `chk1_5_2_${i - 6}`;
          idName = `OTHER_HOSPITAL2_${i - 6}`;
        } else if (i < 24) {
          // （３）心電図検査
          name = `chk1_5_3_${i - 17}`;
          idName = `OTHER_HOSPITAL3_${i - 17}`;
        } else {
          // （４）乳房検査
          name = `chk1_5_4_${i - 23}`;
          idName = `OTHER_HOSPITAL4_${i - 23}`;
        }
        // チェック状態にする
        document.getElementsByName(name)[0].checked = true;
        // ラベルキャプションを赤色にする
        document.getElementById(idName).style.color = 'red';
        // 処理用配列に反映
        chgRsl[i + index].result = chgRsl[i + index].lstresult;
      }
    }

    // 下のフレームのエラーリストを消去
    // parent.lngErrCount = 0;
    // parent.error.document.entryForm.selectState.selectedIndex = 2;
    // parent.error.chgSelect();
  }

  // OCR入力担当者クリア
  clrUser = (index) => {
    this.setChgRsl(index, '');
    if (document.getElementById('OpeName')) {
      document.getElementById('OpeName').innerHTML = '';
    }
  }

  render() {
    const { message, ocrNyuryoku, strOpeNameStc, consult } = this.props;
    errInfoNo = 0;

    if (!ocrNyuryoku || !ocrNyuryoku.ocrresult || ocrNyuryoku.ocrresult.length === 0) {
      return null;
    }

    return (
      <div style={{ minWidth: '1200px' }}>
        <MessageBanner messages={message} />
        {/* ****************************************************** */}
        {/*     現病歴既往歴                                       */}
        {/* ****************************************************** */}
        <div>
          { /* センター使用欄  */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98fb98', marginTop: '2px' }}>
            <span id="Anchor-DiseaseHistory" style={{ position: 'relative', fontWeight: 'bold' }}>現病歴・既往歴問診票</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98fb98', marginLeft: '2px', marginTop: '2px' }}>
            <span style={{ fontWeight: 'bold' }}>{`前回値 ${this.getLstCslDate(ocrNyuryoku)}`}</span>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ position: 'relative', float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>センター使用欄</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>ドック全体</span>
            {this.editRsl(constants.OCRGRP_START1, 'radio', 'opt1_0_1', 0, '1')}<span>はい　</span>
            {this.editRsl(constants.OCRGRP_START1, 'radio', 'opt1_0_1', 0, '2')}<span>いいえ　　　　</span>
            {this.editRsl(constants.OCRGRP_START1 + 1, 'checkbox', 'chk1_0_1', 0, '1')}<span>ＧＦ</span>
            {this.editRsl(constants.OCRGRP_START1 + 2, 'checkbox', 'chk1_0_2', 0, '1')}<span>ＨＰＶ</span>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea0(constants.OCRGRP_START1)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>ブチルスコポラミン可否</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          {this.getResultArea3(constants.OCRGRP_START1 + 3)}
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea3(constants.OCRGRP_START1 + 3)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>朝食摂取の有無</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 4, 'radio', 'opt1_0_3', 0, '1')}<span>はい　</span>
            {this.editRsl(constants.OCRGRP_START1 + 4, 'radio', 'opt1_0_3', 0, '2')}<span>いいえ</span>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea4(constants.OCRGRP_START1 + 4)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>１－a．現在治療中又は定期的に受診中の病気について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: '450px', backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>病名</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '60px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>発症年齢</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '220px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>治療状況</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '464px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>メッセージ</span>
          </div>
          <div style={{ clear: 'left' }} />

          {/* 現病歴・既往歴問診票 １－a． */}
          {this.getDisease1aArea()}

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>１－ｂ．既に治療や定期的な受診が終了した病気について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: '450px', backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>病名</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '60px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>発症年齢</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '220px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>治療状況</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '464px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>メッセージ</span>
          </div>
          <div style={{ clear: 'left' }} />

          {/* 現病歴・既往歴問診票 １－b． */}
          {this.getDisease1bArea()}

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>１－ｃ．ご家族（血縁）の方でかかった病気について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: '450px', backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>病名</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '60px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>発症年齢</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '220px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>続柄</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '464px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>メッセージ</span>
          </div>
          <div style={{ clear: 'left' }} />

          {/* 現病歴・既往歴問診票 １－c． */}
          {this.getDisease1cArea()}

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span id="Anchor-Stomach" style={{ position: 'relative' }}>２．胃検査を受ける方はお答え下さい</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）手術をされた方へ</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 59, 'radio', 'opt1_4_1', 0, '1')}<span id="STOMACH1_1">胃全摘手術　</span>
              {this.editRsl(constants.OCRGRP_START1 + 59, 'radio', 'opt1_4_1', 0, '2')}<span id="STOMACH1_2">胃部分切除　</span>
              {this.editRsl(constants.OCRGRP_START1 + 59, 'radio', 'opt1_4_1', 0, '3')}<span id="STOMACH1_3">内視鏡治療（粘膜切除術など）　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea59(constants.OCRGRP_START1 + 59)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）ヘリコバクター・ピロリに関して</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              <span>ピロリ除菌歴　</span>
              {this.editRsl(constants.OCRGRP_START1 + 60, 'radio', 'opt1_4_2', 0, '1')}<span id="STOMACH2_1">除菌歴なし　</span>
              {this.editRsl(constants.OCRGRP_START1 + 60, 'radio', 'opt1_4_2', 0, '2')}<span id="STOMACH2_2">あり：除菌成功　</span>
              {this.editRsl(constants.OCRGRP_START1 + 60, 'radio', 'opt1_4_2', 0, '3')}<span id="STOMACH2_3">あり：除菌不成功　</span>
              {this.editRsl(constants.OCRGRP_START1 + 60, 'radio', 'opt1_4_2', 0, '4')}<span id="STOMACH2_4">あり：除菌できたか不明　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea60(constants.OCRGRP_START1 + 60)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>３．以前他院で指摘を受けたものがあれば、ご記入下さい。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）上部消化管検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '46px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '46px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 61, 'checkbox', 'chk1_5_1_1', 0, '1')}<span id="OTHER_HOSPITAL1_1">食道ポリープ　</span>
              {this.editRsl(constants.OCRGRP_START1 + 62, 'checkbox', 'chk1_5_1_2', 0, '2')}<span id="OTHER_HOSPITAL1_2">胃がん　</span>
              {this.editRsl(constants.OCRGRP_START1 + 63, 'checkbox', 'chk1_5_1_3', 0, '3')}<span id="OTHER_HOSPITAL1_3">慢性胃炎　</span>
              {this.editRsl(constants.OCRGRP_START1 + 64, 'checkbox', 'chk1_5_1_4', 0, '4')}<span id="OTHER_HOSPITAL1_4">胃ポリープ　</span>
              {this.editRsl(constants.OCRGRP_START1 + 65, 'checkbox', 'chk1_5_1_5', 0, '5')}<span id="OTHER_HOSPITAL1_5">胃潰瘍瘢痕　</span><br />
              {this.editRsl(constants.OCRGRP_START1 + 66, 'checkbox', 'chk1_5_1_6', 0, '6')}<span id="OTHER_HOSPITAL1_6">十二指腸潰瘍瘢痕　</span>
              {this.editRsl(constants.OCRGRP_START1 + 67, 'checkbox', 'chk1_5_1_7', 0, '7')}<span id="OTHER_HOSPITAL1_7">その他　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '46px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea61(constants.OCRGRP_START1 + 61)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）上腹部超音波検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 68, 'checkbox', 'chk1_5_2_1', 0, '1')}<span id="OTHER_HOSPITAL2_1">胆のうポリープ　</span>
              {this.editRsl(constants.OCRGRP_START1 + 69, 'checkbox', 'chk1_5_2_2', 0, '2')}<span id="OTHER_HOSPITAL2_2">胆石　</span>
              {this.editRsl(constants.OCRGRP_START1 + 70, 'checkbox', 'chk1_5_2_3', 0, '3')}<span id="OTHER_HOSPITAL2_3">肝血管腫　</span>
              {this.editRsl(constants.OCRGRP_START1 + 71, 'checkbox', 'chk1_5_2_4', 0, '4')}<span id="OTHER_HOSPITAL2_4">肝のう胞　</span>
              {this.editRsl(constants.OCRGRP_START1 + 72, 'checkbox', 'chk1_5_2_5', 0, '5')}<span id="OTHER_HOSPITAL2_5">脂肪肝　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea68(constants.OCRGRP_START1 + 68)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 73, 'checkbox', 'chk1_5_2_6', 0, '6')}<span id="OTHER_HOSPITAL2_6">腎結石　</span>
              {this.editRsl(constants.OCRGRP_START1 + 74, 'checkbox', 'chk1_5_2_7', 0, '7')}<span id="OTHER_HOSPITAL2_7">腎のう胞　</span>
              {this.editRsl(constants.OCRGRP_START1 + 75, 'checkbox', 'chk1_5_2_8', 0, '8')}<span id="OTHER_HOSPITAL2_8">水腎症　</span>
              {this.editRsl(constants.OCRGRP_START1 + 76, 'checkbox', 'chk1_5_2_9', 0, '9')}<span id="OTHER_HOSPITAL2_9">副腎腫瘍　</span>
              {this.editRsl(constants.OCRGRP_START1 + 77, 'checkbox', 'chk1_5_2_10', 0, '10')}<span id="OTHER_HOSPITAL2_10">リンパ節腫大　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea73(constants.OCRGRP_START1 + 73)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 78, 'checkbox', 'chk1_5_2_11', 0, '11')}<span id="OTHER_HOSPITAL2_11">その他　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（３）心電図検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '46px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '46px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 79, 'checkbox', 'chk1_5_3_1', 0, '1')}<span id="OTHER_HOSPITAL3_1">ＷＰＷ症候群　</span>
              {this.editRsl(constants.OCRGRP_START1 + 80, 'checkbox', 'chk1_5_3_2', 0, '2')}<span id="OTHER_HOSPITAL3_2">完全右脚ブロック　</span>
              {this.editRsl(constants.OCRGRP_START1 + 81, 'checkbox', 'chk1_5_3_3', 0, '3')}<span id="OTHER_HOSPITAL3_3">不完全右脚ブロック　</span>
              {this.editRsl(constants.OCRGRP_START1 + 82, 'checkbox', 'chk1_5_3_4', 0, '4')}<span id="OTHER_HOSPITAL3_4">不整脈　</span>
              {this.editRsl(constants.OCRGRP_START1 + 83, 'checkbox', 'chk1_5_3_5', 0, '5')}<span id="OTHER_HOSPITAL3_5">右胸心　</span><br />
              {this.editRsl(constants.OCRGRP_START1 + 84, 'checkbox', 'chk1_5_3_6', 0, '6')}<span id="OTHER_HOSPITAL3_6">その他　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '46px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea79(constants.OCRGRP_START1 + 79)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（４）乳房検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 85, 'checkbox', 'chk1_5_4_1', 0, '1')}<span id="OTHER_HOSPITAL4_1">乳腺症　</span>
              {this.editRsl(constants.OCRGRP_START1 + 86, 'checkbox', 'chk1_5_4_2', 0, '2')}<span id="OTHER_HOSPITAL4_2">繊維線種　</span>
              {this.editRsl(constants.OCRGRP_START1 + 87, 'checkbox', 'chk1_5_4_3', 0, '3')}<span id="OTHER_HOSPITAL4_3">乳房形成術　</span>
              {this.editRsl(constants.OCRGRP_START1 + 88, 'checkbox', 'chk1_5_4_4', 0, '4')}<span id="OTHER_HOSPITAL4_4">その他　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea85(constants.OCRGRP_START1 + 85)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>４．女性の方は、下記の質問にお答えください。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 89, 'radio', 'opt1_5_5', 0, '1')}<span>はい</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea89(constants.OCRGRP_START1 + 89)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 89, 'radio', 'opt1_5_5', 0, '2')}<span>いいえ</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          {/* ****************************************************** */}
          {/*     生活習慣問診１                                     */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98fb98', marginTop: '2px' }}>
            <span id="Anchor-LifeHabit1" style={{ position: 'relative' }}>生活習慣病問診票（１）</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98fb98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>１．体重について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）１８～２０歳の体重は何ｋｇでしたか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2, 'text', `Rsl[${constants.OCRGRP_START2}]`, 4, '')}ｋｇ
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea90(constants.OCRGRP_START2)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）この１年での体重の変動はどうですか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 1, 'radio', 'opt2_1_2', 0, '4')}<span>3ｋｇ以上増加した　</span>
              {this.editRsl(constants.OCRGRP_START2 + 1, 'radio', 'opt2_1_2', 0, '2')}<span>変動なし　</span>
              {this.editRsl(constants.OCRGRP_START2 + 1, 'radio', 'opt2_1_2', 0, '5')}<span>3ｋｇ以上減少した　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea91(constants.OCRGRP_START2 + 1)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>２．飲酒について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）週に何日飲みますか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 2, 'radio', 'opt2_2_1', 0, '1')}<span>習慣的に飲む　</span>
              <span>（週</span>{this.editRsl(constants.OCRGRP_START2 + 3, 'text', `Rsl[${constants.OCRGRP_START2 + 3}]`, 5, '')}<span>日）　</span>
              {this.editRsl(constants.OCRGRP_START2 + 2, 'radio', 'opt2_2_1', 0, '2')}<span>ときどき飲む　</span>
              {this.editRsl(constants.OCRGRP_START2 + 2, 'radio', 'opt2_2_1', 0, '3')}<span>飲まない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea92(constants.OCRGRP_START2 + 2)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）１日の飲酒量はどのくらいですか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 4, 'text', `Rsl[${constants.OCRGRP_START2 + 4}]`, 5, '')}<span>本（ビール大瓶）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea94(constants.OCRGRP_START2 + 4)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 5, 'text', `Rsl[${constants.OCRGRP_START2 + 5}]`, 5, '')}<span>本（ビール３５０ml缶）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea94(constants.OCRGRP_START2 + 5)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 6, 'text', `Rsl[${constants.OCRGRP_START2 + 6}]`, 5, '')}<span>本（ビール５００ml缶）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea94(constants.OCRGRP_START2 + 6)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 7, 'text', `Rsl[${constants.OCRGRP_START2 + 7}]`, 5, '')}<span>合（日本酒）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea94(constants.OCRGRP_START2 + 7)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 8, 'text', `Rsl[${constants.OCRGRP_START2 + 8}]`, 5, '')}<span>杯（焼酎）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea94(constants.OCRGRP_START2 + 8)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 9, 'text', `Rsl[${constants.OCRGRP_START2 + 9}]`, 5, '')}<span>杯（ワイン）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea94(constants.OCRGRP_START2 + 9)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 10, 'text', `Rsl[${constants.OCRGRP_START2 + 10}]`, 5, '')}<span>杯（ウイスキー・ブランデー）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea94(constants.OCRGRP_START2 + 10)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 11, 'text', `Rsl[${constants.OCRGRP_START2 + 11}]`, 5, '')}<span>杯（その他）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea94(constants.OCRGRP_START2 + 11)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>３．たばこについて</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）現在の喫煙について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 12, 'radio', 'opt2_3_1', 0, '1')}<span>吸っている　</span>
              {this.editRsl(constants.OCRGRP_START2 + 12, 'radio', 'opt2_3_1', 0, '2')}<span>吸わない　</span>
              {this.editRsl(constants.OCRGRP_START2 + 12, 'radio', 'opt2_3_1', 0, '3')}<span>過去に吸っていた　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea102(constants.OCRGRP_START2 + 12)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）吸い始めた年齢</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 13, 'text', `Rsl[${constants.OCRGRP_START2 + 13}]`, 5, '')}<span>歳（吸い始めた年齢）　</span>
              {this.editRsl(constants.OCRGRP_START2 + 14, 'text', `Rsl[${constants.OCRGRP_START2 + 14}]`, 5, '')}<span>歳（やめた年齢）　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea103(constants.OCRGRP_START2 + 13)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（３）１日の喫煙本数</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 15, 'text', `Rsl[${constants.OCRGRP_START2 + 15}]`, 5, '')}<span>本</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea105(constants.OCRGRP_START2 + 15)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>４．運動について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）運動不足と思いますか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 16, 'radio', 'opt2_4_1', 0, '1')}<span>思う　</span>
              {this.editRsl(constants.OCRGRP_START2 + 16, 'radio', 'opt2_4_1', 0, '2')}<span>思わない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea106(constants.OCRGRP_START2 + 16)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）１日のおよそ何分くらい歩いてますか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 17, 'text', `Rsl[${constants.OCRGRP_START2 + 17}]`, 5, '')}<span>分</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea107(constants.OCRGRP_START2 + 17)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（３）日常における身体活動はどのくらいですか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 18, 'radio', 'opt2_4_3', 0, '1')}<span>よく体を動かす　</span>
              {this.editRsl(constants.OCRGRP_START2 + 18, 'radio', 'opt2_4_3', 0, '2')}<span>普通に動いている　</span>
              {this.editRsl(constants.OCRGRP_START2 + 18, 'radio', 'opt2_4_3', 0, '3')}<span>あまり活動的でない　</span>
              {this.editRsl(constants.OCRGRP_START2 + 18, 'radio', 'opt2_4_3', 0, '4')}<span>ほとんど体を動かさない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea108(constants.OCRGRP_START2 + 18)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（４）運動習慣は</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 19, 'radio', 'opt2_4_4', 0, '1')}<span>ほとんど毎日　</span>
              {this.editRsl(constants.OCRGRP_START2 + 19, 'radio', 'opt2_4_4', 0, '2')}<span>週３～５日　</span>
              {this.editRsl(constants.OCRGRP_START2 + 19, 'radio', 'opt2_4_4', 0, '3')}<span>週１～２日　</span>
              {this.editRsl(constants.OCRGRP_START2 + 19, 'radio', 'opt2_4_4', 0, '4')}<span>ほとんどしない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea109(constants.OCRGRP_START2 + 19)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>５．睡眠について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　睡眠は十分ですか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 20, 'radio', 'opt2_4_5', 0, '1')}<span>はい　</span>
              {this.editRsl(constants.OCRGRP_START2 + 20, 'radio', 'opt2_4_5', 0, '2')}<span>寝不足を感じる　　　　　</span>
              <span>睡眠時間（</span>{this.editRsl(constants.OCRGRP_START2 + 21, 'text', `Rsl[${constants.OCRGRP_START2 + 21}]`, 5, '')}<span>時間）　</span>
              <span>就寝時刻（</span>{this.editRsl(constants.OCRGRP_START2 + 22, 'text', `Rsl[${constants.OCRGRP_START2 + 22}]`, 5, '')}<span>時）　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea110(constants.OCRGRP_START2 + 20)}
          </div>
          <div style={{ clear: 'left' }} />
          { /* ==============add - start============== */}
          {/* ６．歯磨きについて */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>６．歯磨きについて</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　歯磨きについて</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 23, 'radio', 'opt2_4_6', 0, '1')}<span>毎食後に磨く　</span>
              {this.editRsl(constants.OCRGRP_START2 + 23, 'radio', 'opt2_4_6', 0, '4')}<span>１日１～２回は磨く　　　　　</span>
              {this.editRsl(constants.OCRGRP_START2 + 23, 'radio', 'opt2_4_6', 0, '3')}<span>１回も磨かない　　　　　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea113(constants.OCRGRP_START2 + 23)}
          </div>
          <div style={{ clear: 'left' }} />
          {/*  ======= ７．その他の質問 ======= */ }
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>７．その他の質問</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）あなたの現在の職業は</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_4_7_1', 0, '1')}<span>肉体頭脳を要す労働　</span>
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_4_7_1', 0, '2')}<span>主に肉体的な労働　</span>
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_4_7_1', 0, '3')}<span>主に頭脳的な労働　</span>
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_4_7_1', 0, '4')}<span>主に座り仕事　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea114(constants.OCRGRP_START2 + 24)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '90px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_71', 0, '5')}<span>特に仕事をもっていない　</span>
            </div>
          </div>

          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）休日は何日とれますか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 25, 'radio', 'opt2_4_7_2', 0, '1')}<span>週3日以上　</span>
              {this.editRsl(constants.OCRGRP_START2 + 25, 'radio', 'opt2_4_7_2', 0, '2')}<span>週2日以上　</span>
              {this.editRsl(constants.OCRGRP_START2 + 25, 'radio', 'opt2_4_7_2', 0, '3')}<span>週1日　</span>
              {this.editRsl(constants.OCRGRP_START2 + 25, 'radio', 'opt2_4_7_2', 0, '4')}<span>月3日以下　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea115(constants.OCRGRP_START2 + 25)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（３）職場等への主な移動手段</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 26, 'radio', 'opt2_4_7_3', 0, '1')}<span>徒歩　</span>
              {this.editRsl(constants.OCRGRP_START2 + 26, 'radio', 'opt2_4_7_3', 0, '2')}<span>自転車　</span>
              {this.editRsl(constants.OCRGRP_START2 + 26, 'radio', 'opt2_4_7_3', 0, '3')}<span>自動車（２輪を含む）　</span>
              {this.editRsl(constants.OCRGRP_START2 + 26, 'radio', 'opt2_4_7_3', 0, '4')}<span>電車・バス　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea116(constants.OCRGRP_START2 + 26)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（４）職場等までの片道移動時間／徒歩時間は</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 27, 'text', `Rsl[${constants.OCRGRP_START2 + 27}]`, 5, '')}<span>分（片道の移動時間）　　</span>
              {this.editRsl(constants.OCRGRP_START2 + 28, 'text', `Rsl[${constants.OCRGRP_START2 + 28}]`, 5, '')}<span>分（片道の歩行時間）　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea117(constants.OCRGRP_START2 + 27)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（５）配偶者は</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 29, 'radio', 'opt2_4_7_5', 0, '1')}<span>あり　</span>
              {this.editRsl(constants.OCRGRP_START2 + 29, 'radio', 'opt2_4_7_5', 0, '2')}<span>なし　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea118(constants.OCRGRP_START2 + 29)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（６）一緒にくらしているのは</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 30, 'checkbox', 'chk2_4_7_6_1', 0, '1')}<span>親　</span>
              {this.editRsl(constants.OCRGRP_START2 + 31, 'checkbox', 'chk2_4_7_6_2', 0, '2')}<span>配偶者　</span>
              {this.editRsl(constants.OCRGRP_START2 + 32, 'checkbox', 'chk2_4_7_6_3', 0, '3')}<span>子供　</span>
              {this.editRsl(constants.OCRGRP_START2 + 33, 'checkbox', 'chk2_4_7_6_4', 0, '4')}<span>独居　</span>
              {this.editRsl(constants.OCRGRP_START2 + 34, 'checkbox', 'chk2_4_7_6_5', 0, '5')}<span>その他</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea119(constants.OCRGRP_START2 + 30)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（７）現在の生活に満足していますか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 35, 'radio', 'opt2_4_7_7', 0, '1')}<span>満足している　</span>
              {this.editRsl(constants.OCRGRP_START2 + 35, 'radio', 'opt2_4_7_7', 0, '2')}<span>やや満足している　</span>
              {this.editRsl(constants.OCRGRP_START2 + 35, 'radio', 'opt2_4_7_7', 0, '3')}<span>やや不満　</span>
              {this.editRsl(constants.OCRGRP_START2 + 35, 'radio', 'opt2_4_7_7', 0, '4')}<span>不満足　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea120(constants.OCRGRP_START2 + 35)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（８）１年以内に大変つらい思いをしたことは</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 36, 'radio', 'opt2_4_7_8', 0, '1')}<span>全く無かった　　</span>
              {this.editRsl(constants.OCRGRP_START2 + 36, 'radio', 'opt2_4_7_8', 0, '2')}<span>ややつらいことがあった　</span>
              {this.editRsl(constants.OCRGRP_START2 + 36, 'radio', 'opt2_4_7_8', 0, '3')}<span>つらいことがあった　</span>
              {this.editRsl(constants.OCRGRP_START2 + 36, 'radio', 'opt2_4_7_8', 0, '4')}<span>大変つらかった　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea121(constants.OCRGRP_START2 + 36)}
          </div>
          <div style={{ clear: 'left' }} />
          { /* ==============add - end============== */ }
          {/* 自覚症状表示 */}
          {this.editJikakushoujyou(constants.OCRGRP_START2 + 37)}

          {/* ****************************************************** */}
          {/*     生活習慣問診２                                     */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98fb98', marginTop: '2px' }}>
            <span id="Anchor-LifeHabit2" style={{ position: 'relative' }}>生活習慣病問診票（２）</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98fb98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>１．Ａ型行動パターン・テスト</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '0px' }}>
              {this.editRsl(constants.OCRGRP_START3, 'checkbox', 'chk3_1_1', 0, '1')}<span style={{ fontWeight: 'bold' }}>本人希望により未回答</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea151(constants.OCRGRP_START3)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>1)ストレス,緊張時上腹部に痛み</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 1, 'radio', 'opt3_1_1', 0, '1')}<span style={{ color: 'gray' }}>全くない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 1, 'radio', 'opt3_1_1', 0, '2')}<span style={{ color: 'gray' }}>時にはある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 1, 'radio', 'opt3_1_1', 0, '3')}<span style={{ color: 'gray' }}>しばしばある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }} />
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 1)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>2)気性は激しい方ですか｡</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 2, 'radio', 'opt3_1_2', 0, '1')}<span style={{ color: 'gray' }}>穏やかな方</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 2, 'radio', 'opt3_1_2', 0, '2')}<span style={{ color: 'gray' }}>普通</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 2, 'radio', 'opt3_1_2', 0, '3')}<span style={{ color: 'gray' }}>幾分激しい</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 2, 'radio', 'opt3_1_2', 0, '4')}<span style={{ color: 'gray' }}>非常に激しい</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 2)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>3)責任感が強いと言われた</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 3, 'radio', 'opt3_1_3', 0, '1')}<span style={{ color: 'gray' }}>全くない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 3, 'radio', 'opt3_1_3', 0, '2')}<span style={{ color: 'gray' }}>時々ある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 3, 'radio', 'opt3_1_3', 0, '3')}<span style={{ color: 'gray' }}>しばしばある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 3, 'radio', 'opt3_1_3', 0, '4')}<span style={{ color: 'gray' }}>いつもある</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 3)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>4)仕事に自信を持っている</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 4, 'radio', 'opt3_1_4', 0, '1')}<span style={{ color: 'gray' }}>全くない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 4, 'radio', 'opt3_1_4', 0, '2')}<span style={{ color: 'gray' }}>あまりない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 4, 'radio', 'opt3_1_4', 0, '3')}<span style={{ color: 'gray' }}>ある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 4, 'radio', 'opt3_1_4', 0, '4')}<span style={{ color: 'gray' }}>非常にある</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 4)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>5)特別に早起きして職場に行く</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 5, 'radio', 'opt3_1_5', 0, '1')}<span style={{ color: 'gray' }}>全くない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 5, 'radio', 'opt3_1_5', 0, '2')}<span style={{ color: 'gray' }}>時々ある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 5, 'radio', 'opt3_1_5', 0, '3')}<span style={{ color: 'gray' }}>しばしばある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 5, 'radio', 'opt3_1_5', 0, '4')}<span style={{ color: 'gray' }}>常にある</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 5)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>6)約束の時間に遅れる方</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 6, 'radio', 'opt3_1_6', 0, '1')}<span style={{ color: 'gray' }}>よく遅れる</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 6, 'radio', 'opt3_1_6', 0, '2')}<span style={{ color: 'gray' }}>時々遅れる</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 6, 'radio', 'opt3_1_6', 0, '3')}<span style={{ color: 'gray' }}>決して遅れない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 6, 'radio', 'opt3_1_6', 0, '4')}<span style={{ color: 'gray' }}>30分前に行く</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 6)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>7)正しいと思うことは貫く</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 7, 'radio', 'opt3_1_7', 0, '1')}<span style={{ color: 'gray' }}>全くない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 7, 'radio', 'opt3_1_7', 0, '2')}<span style={{ color: 'gray' }}>時々ある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 7, 'radio', 'opt3_1_7', 0, '3')}<span style={{ color: 'gray' }}>しばしばある</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 7, 'radio', 'opt3_1_7', 0, '4')}<span style={{ color: 'gray' }}>常にある</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 7)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>8)数日間旅行すると仮定</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 8, 'radio', 'opt3_1_8', 0, '1')}<span style={{ color: 'gray' }}>成り行き任せ</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 8, 'radio', 'opt3_1_8', 0, '2')}<span style={{ color: 'gray' }}>1日単位に計画</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 8, 'radio', 'opt3_1_8', 0, '3')}<span style={{ color: 'gray' }}>時間単位に計画</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }} />
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 8)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>9)他人から指示された場合</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 9, 'radio', 'opt3_1_9', 0, '1')}<span style={{ color: 'gray' }}>気が楽だと思う</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 9, 'radio', 'opt3_1_9', 0, '2')}<span style={{ color: 'gray' }}>気にとめない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 9, 'radio', 'opt3_1_9', 0, '3')}<span style={{ color: 'gray' }}>嫌な気がする</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 9, 'radio', 'opt3_1_9', 0, '4')}<span style={{ color: 'gray' }}>怒りを覚える</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 9)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>10)車を追い抜かれた場合</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 10, 'radio', 'opt3_1_10', 0, '1')}<span style={{ color: 'gray' }}>マイペース</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 10, 'radio', 'opt3_1_10', 0, '2')}<span style={{ color: 'gray' }}>追越し返す</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }} />
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }} />
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 10)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '220px', marginTop: '2px', backgroundColor: '#eeeeee' }}>
              <span>11)帰宅時リラックスした気分</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 11, 'radio', 'opt3_1_11', 0, '1')}<span style={{ color: 'gray' }}>すぐになれる</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 11, 'radio', 'opt3_1_11', 0, '2')}<span style={{ color: 'gray' }}>比較的早く</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 11, 'radio', 'opt3_1_11', 0, '3')}<span style={{ color: 'gray' }}>少しイライラ</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 11, 'radio', 'opt3_1_11', 0, '4')}<span style={{ color: 'gray' }}>八つ当たり</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea152(constants.OCRGRP_START3 + 11)}
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            {/* <span>２．最近１ヶ月の状態</span> */}
            <span>２．ストレス・コーピングテスト</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '4px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '0px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 12, 'checkbox', 'chk3_2_1', 0, '1')}<span style={{ fontWeight: 'bold' }}>本人希望により未回答</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea163(constants.OCRGRP_START3 + 12)}
          </div>
          <div style={{ clear: 'left' }} />
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} >
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
            <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          </div>
          <div style={{ border: '1px solid ', float: 'left', height: '398px', width: '896px', marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginTop: '1px', marginLeft: '3px' }} />
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '1px', marginLeft: '2px', textAlign: 'center' }}>
                {/*  <span>ほとんどなかった</span> */}
                <span>全くしない</span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '1px', marginLeft: '2px', textAlign: 'center' }}>
                {/*  <span>ときどきあった</span> */}
                <span>時にはある</span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '1px', marginLeft: '2px', textAlign: 'center' }}>
                {/*  <span>しばしばあった</span> */}
                <span>時にはある</span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '1px', marginLeft: '2px', textAlign: 'center' }}>
                {/*  <span>ほとんどいつもあった</span> */}
                <span>常にある</span>
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>1)ひどく疲れた</span> */}
                <span> 1)積極的に解消しようと努力する</span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 13, 'radio', 'opt3_2_1', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 13, 'radio', 'opt3_2_1', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 13, 'radio', 'opt3_2_1', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 13, 'radio', 'opt3_2_1', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>2)へとへとだ</span> */}
                <span> 2)自分への挑戦と受け止める </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 14, 'radio', 'opt3_2_2', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 14, 'radio', 'opt3_2_2', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 14, 'radio', 'opt3_2_2', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 14, 'radio', 'opt3_2_2', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>3)だるい</span> */}
                <span> 3)一休みするより頑張ろうとする </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 15, 'radio', 'opt3_2_3', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 15, 'radio', 'opt3_2_3', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 15, 'radio', 'opt3_2_3', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 15, 'radio', 'opt3_2_3', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>4)気がはりつめている</span> */}
                <span> 4)衝動買いや高価な買物をする </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 16, 'radio', 'opt3_2_4', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 16, 'radio', 'opt3_2_4', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 16, 'radio', 'opt3_2_4', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 16, 'radio', 'opt3_2_4', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>5)不安だ</span> */}
                <span> 5)同僚や家族と出歩いたり飲み食いする </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 17, 'radio', 'opt3_2_5', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 17, 'radio', 'opt3_2_5', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 17, 'radio', 'opt3_2_5', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 17, 'radio', 'opt3_2_5', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>6)落ち着かない</span> */}
                <span> 6)何か新しい事を始めようとする </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 18, 'radio', 'opt3_2_6', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 18, 'radio', 'opt3_2_6', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 18, 'radio', 'opt3_2_6', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 18, 'radio', 'opt3_2_6', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>7)ゆううつだ</span> */}
                <span> 7)今の状況から抜け出る事は無理だと思う </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 19, 'radio', 'opt3_2_7', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 19, 'radio', 'opt3_2_7', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 19, 'radio', 'opt3_2_7', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 19, 'radio', 'opt3_2_7', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>8)何をするのも面倒だ</span> */}
                <span> 8)楽しかったことをボンヤリ考える </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 20, 'radio', 'opt3_2_8', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 20, 'radio', 'opt3_2_8', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 20, 'radio', 'opt3_2_8', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 20, 'radio', 'opt3_2_8', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            {/* =========================add - start========================= */}
            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                {/* <span>9)気分が晴れない</span> */}
                <span> 9)どうすれば良かったのかを思い悩む </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 21, 'radio', 'opt3_2_9', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 21, 'radio', 'opt3_2_9', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 21, 'radio', 'opt3_2_9', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 21, 'radio', 'opt3_2_9', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                <span>10)現在の状況について考えないようにする</span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 22, 'radio', 'opt3_2_10', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 22, 'radio', 'opt3_2_10', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 22, 'radio', 'opt3_2_10', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 22, 'radio', 'opt3_2_10', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                <span>11)体の調子の悪い時には病院に行こうかと思う </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 23, 'radio', 'opt3_2_11', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 23, 'radio', 'opt3_2_11', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 23, 'radio', 'opt3_2_11', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 23, 'radio', 'opt3_2_11', 0, '4')}
              </div>
            </div>
            <div style={{ clear: 'left' }} />

            <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '360px', marginLeft: '3px', marginTop: '2px' }}>
                <span>12)以前よりタバコ・酒・食事の量が増える </span>
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 24, 'radio', 'opt3_2_12', 0, '1')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 24, 'radio', 'opt3_2_12', 0, '2')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 24, 'radio', 'opt3_2_12', 0, '3')}
              </div>
              <div style={{ border: '1px solid ', float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px', textAlign: 'center' }}>
                {this.editRsl(constants.OCRGRP_START3 + 24, 'radio', 'opt3_2_12', 0, '4')}
              </div>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '306px', marginTop: '2px' }} >
            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              <span />
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 13)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 14)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 15)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 16)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 17)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 18)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 19)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 20)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 21)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 22)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 23)}
            </div>

            <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '3px' }}>
              {/* 前回値 */}
              {this.getLstResultArea0164btw0175(constants.OCRGRP_START3 + 24)}
            </div>
          </div>
          <div style={{ clear: 'left' }} />
          {/* =========================add - end========================= */}

          {(consult && consult.gender === 2) &&
            <div>
              {/* ****************************************************** */}
              {/*     婦人科問診                                         */}
              {/* ****************************************************** */}
              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98fb98', marginTop: '2px' }}>
                <span id="Anchor-Fujinka" style={{ position: 'relative' }}>婦人科問診票</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98fb98', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>1.子宮頸がんの検診を受けたことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4, 'radio', 'opt4_1', 0, '5')}<span>受けたことなし　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea176(constants.OCRGRP_START4)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4, 'radio', 'opt4_1', 0, '6')}<span>1年未満　</span>
                  {this.editRsl(constants.OCRGRP_START4, 'radio', 'opt4_1', 0, '7')}<span>1～3年前　</span>
                  {this.editRsl(constants.OCRGRP_START4, 'radio', 'opt4_1', 0, '8')}<span>3年以上前　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>2.検診の結果は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 1, 'radio', 'opt4_2_1', 0, '1')}<span>異常なし　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 1, 'radio', 'opt4_2_1', 0, '2')}<span>異型上皮</span>
                  <span>（クラス</span>
                  {this.editRsl(constants.OCRGRP_START4 + 2, 'radio', 'opt4_2_2', 0, '1')}<span>Ⅲa　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 2, 'radio', 'opt4_2_2', 0, '2')}<span>Ⅲb　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 2, 'radio', 'opt4_2_2', 0, '3')}<span>Ⅲ　</span>
                  <span>）</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea177(constants.OCRGRP_START4 + 1)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 1, 'radio', 'opt4_2_1', 0, '4')}<span>子宮頸がんの疑い　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 1, 'radio', 'opt4_2_1', 0, '9')}<span>その他　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>3.検診を受けた施設は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 3, 'radio', 'opt4_3', 0, '4')}<span>当センター　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 3, 'radio', 'opt4_3', 0, '5')}<span>当病院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 3, 'radio', 'opt4_3', 0, '6')}<span>他施設　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea179(constants.OCRGRP_START4 + 3)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>4.過去の子宮頸がん検査で異常は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 4, 'radio', 'opt4_4_1', 0, '1')}<span>いいえ　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 4, 'radio', 'opt4_4_1', 0, '2')}<span>はい　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea180(constants.OCRGRP_START4 + 4)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '0px' }}>
                  <span>　　「はい」の場合</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>結果：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 5, 'radio', 'opt4_4_2', 0, '1')}<span>異型上皮</span>
                  <span>（クラス</span>
                  {this.editRsl(constants.OCRGRP_START4 + 6, 'radio', 'opt4_4_3', 0, '1')}<span>Ⅲa　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 6, 'radio', 'opt4_4_3', 0, '2')}<span>Ⅲb　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 6, 'radio', 'opt4_4_3', 0, '3')}<span>Ⅲ　</span>
                  <span>）</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea181182(constants.OCRGRP_START4 + 5)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '100px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 5, 'radio', 'opt4_4_2', 0, '2')}<span>子宮頸がんの疑い　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 5, 'radio', 'opt4_4_2', 0, '9')}<span>その他　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea181(constants.OCRGRP_START4 + 5)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>時期：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 7, 'radio', 'opt4_4_4', 0, '1')}<span>1年未満　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 7, 'radio', 'opt4_4_4', 0, '2')}<span>1～3年前　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 7, 'radio', 'opt4_4_4', 0, '3')}<span>3年以上前　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea183(constants.OCRGRP_START4 + 7)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>施設：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 8, 'radio', 'opt4_4_5', 0, '1')}<span>当センター　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 8, 'radio', 'opt4_4_5', 0, '2')}<span>当病院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 8, 'radio', 'opt4_4_5', 0, '3')}<span>他施設　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea184(constants.OCRGRP_START4 + 8)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>5.ＨＰＶ(ヒトパピローマウィルス）検査を受けたことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 9, 'radio', 'opt4_5_1', 0, '1')}<span>いいえ　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 9, 'radio', 'opt4_5_1', 0, '2')}<span>はい　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea185(constants.OCRGRP_START4 + 9)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '0px' }}>
                  <span>　　「はい」の場合</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>結果：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 10, 'radio', 'opt4_5_2', 0, '1')}<span>陰性　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 10, 'radio', 'opt4_5_2', 0, '2')}<span>陽性</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea186(constants.OCRGRP_START4 + 10)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>時期：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 11, 'radio', 'opt4_5_3', 0, '1')}<span>1年未満　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 11, 'radio', 'opt4_5_3', 0, '2')}<span>1～3年前　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 11, 'radio', 'opt4_5_3', 0, '3')}<span>3年以上前　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea187(constants.OCRGRP_START4 + 11)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>施設：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 12, 'radio', 'opt4_5_4', 0, '1')}<span>当センター　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 12, 'radio', 'opt4_5_4', 0, '2')}<span>当病院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 12, 'radio', 'opt4_5_4', 0, '3')}<span>他施設　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea188(constants.OCRGRP_START4 + 12)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>6.子宮体がん検査を受けたことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 13, 'radio', 'opt4_6_1', 0, '1')}<span>いいえ　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 13, 'radio', 'opt4_6_1', 0, '2')}<span>はい　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea189(constants.OCRGRP_START4 + 13)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '0px' }}>
                  <span>　　「はい」の場合</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>結果：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 14, 'radio', 'opt4_6_2', 0, '1')}<span>異常なし</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea190191(constants.OCRGRP_START4 + 14)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '100px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 14, 'radio', 'opt4_6_2', 0, '2')}<span>擬陽性</span>
                  <span>（クラス</span>
                  {this.editRsl(constants.OCRGRP_START4 + 15, 'radio', 'opt4_6_3', 0, '1')}<span>Ⅲa　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 15, 'radio', 'opt4_6_3', 0, '2')}<span>Ⅲb　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 15, 'radio', 'opt4_6_3', 0, '3')}<span>Ⅲ　</span>
                  <span>）</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '100px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 14, 'radio', 'opt4_6_2', 0, '3')}<span>子宮体がんの疑い　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 14, 'radio', 'opt4_6_2', 0, '9')}<span>その他　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea190(constants.OCRGRP_START4 + 14)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>時期：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 16, 'radio', 'opt4_6_4', 0, '1')}<span>1年未満　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 16, 'radio', 'opt4_6_4', 0, '2')}<span>1～3年前　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 16, 'radio', 'opt4_6_4', 0, '3')}<span>3年以上前　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea192(constants.OCRGRP_START4 + 16)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', textAlign: 'right', width: '100px' }}>
                  <span>施設：</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 17, 'radio', 'opt4_6_5', 0, '1')}<span>当センター　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 17, 'radio', 'opt4_6_5', 0, '2')}<span>当病院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 17, 'radio', 'opt4_6_5', 0, '3')}<span>他施設　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea193(constants.OCRGRP_START4 + 17)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>7.婦人科の病気をしたことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 18, 'checkbox', 'chk4_7_1', 0, '1')}<span>ない　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 19, 'checkbox', 'chk4_7_2', 0, '2')}<span>子宮筋腫　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 20, 'checkbox', 'chk4_7_3', 0, '11')}<span>子宮頸管ポリープ　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea194(constants.OCRGRP_START4 + 18)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 21, 'checkbox', 'chk4_7_4', 0, '13')}<span>内性子宮内膜症（子宮腺筋症）　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 22, 'checkbox', 'chk4_7_5', 0, '14')}<span>外性子宮内膜症（チョコレートのう胞など）　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea197(constants.OCRGRP_START4 + 21)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 23, 'checkbox', 'chk4_7_6', 0, '15')}<span>子宮頸がん　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 24, 'checkbox', 'chk4_7_7', 0, '16')}<span>子宮体がん　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 25, 'checkbox', 'chk4_7_8', 0, '17')}<span>卵巣がん</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea199(constants.OCRGRP_START4 + 23)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 26, 'checkbox', 'chk4_7_9', 0, '18')}<span>良性卵巣腫瘍（右）　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 27, 'checkbox', 'chk4_7_10', 0, '19')}<span>良性卵巣腫瘍（左）　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 28, 'checkbox', 'chk4_7_11', 0, '22')}<span>繊毛性疾患　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea202(constants.OCRGRP_START4 + 26)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 29, 'checkbox', 'chk4_7_12', 0, '20')}<span>付属器炎　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 30, 'checkbox', 'chk4_7_13', 0, '4')}<span>膣炎　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 31, 'checkbox', 'chk4_7_14', 0, '21')}<span>膀胱子宮脱　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea205(constants.OCRGRP_START4 + 29)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 32, 'checkbox', 'chk4_7_15', 0, '9')}<span>乳がん　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 33, 'checkbox', 'chk4_7_16', 0, '90')}<span>その他　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea208(constants.OCRGRP_START4 + 32)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>8.今までにホルモン療法を受けたことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 34, 'radio', 'opt4_8', 0, '1')}<span>受けたことなし</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea210no1(constants.OCRGRP_START4 + 34)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 34, 'radio', 'opt4_8', 0, '2')}<span>ある　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 35, 'text', `Rsl[${constants.OCRGRP_START4 + 35}]`, 5, '')}<span>歳から</span>
                  {this.editRsl(constants.OCRGRP_START4 + 36, 'text', `Rsl[${constants.OCRGRP_START4 + 36}]`, 5, '')}<span>年間</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea210no2(constants.OCRGRP_START4 + 34)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 37, 'checkbox', 'chk4_8', 0, '1')}<span>現在不妊治療中</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea213(constants.OCRGRP_START4 + 37)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>9.今までに病気で婦人科の手術をしたこと</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 38, 'radio', 'opt4_9', 0, '1')}<span>受けたことなし　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 38, 'radio', 'opt4_9', 0, '2')}<span>はい　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea214(constants.OCRGRP_START4 + 38)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '0px' }}>
                  <span>　　「はい」の場合</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '100px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 39, 'checkbox', 'chk4_9_1', 0, '1')}<span>右卵巣</span>
                </div>
                <div style={{ float: 'left', width: '180px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 41, 'radio', 'opt4_9_1_1', 0, '1')}<span>全摘　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 41, 'radio', 'opt4_9_1_1', 0, '2')}<span>部分切除</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 40, 'radio', 'opt4_9_1_2', 0, '1')}<span>良性　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 40, 'radio', 'opt4_9_1_2', 0, '2')}<span>境界型　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 40, 'radio', 'opt4_9_1_2', 0, '3')}<span>悪性　　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea215(constants.OCRGRP_START4 + 39)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '315px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 42, 'text', `Rsl[${constants.OCRGRP_START4 + 42}]`, 3, '')}<span>歳　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 43, 'radio', 'opt4_9_1_3', 0, '1')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 43, 'radio', 'opt4_9_1_3', 0, '2')}<span>他院　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea216(constants.OCRGRP_START4 + 40)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '100px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 44, 'checkbox', 'chk4_9_2', 0, '1')}<span>左卵巣</span>
                </div>
                <div style={{ float: 'left', width: '180px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 46, 'radio', 'opt4_9_2_1', 0, '1')}<span>全摘　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 46, 'radio', 'opt4_9_2_1', 0, '2')}<span>部分切除</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 45, 'radio', 'opt4_9_2_2', 0, '1')}<span>良性　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 45, 'radio', 'opt4_9_2_2', 0, '2')}<span>境界型　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 45, 'radio', 'opt4_9_2_2', 0, '3')}<span>悪性　　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea220(constants.OCRGRP_START4 + 44)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '315px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 47, 'text', `Rsl[${constants.OCRGRP_START4 + 47}]`, 3, '')}<span>歳　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 48, 'radio', 'opt4_9_2_3', 0, '1')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 48, 'radio', 'opt4_9_2_3', 0, '2')}<span>他院　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea221(constants.OCRGRP_START4 + 45)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '100px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 49, 'checkbox', 'chk4_9_3', 0, '1')}<span>子宮全摘術</span>
                </div>
                <div style={{ float: 'left', width: '180px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 50, 'radio', 'opt4_9_3_1', 0, '1')}<span>膣式　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 50, 'radio', 'opt4_9_3_1', 0, '2')}<span>腹式</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 50, 'radio', 'opt4_9_3_1', 0, '3')}<span>その他</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea225(constants.OCRGRP_START4 + 49)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '315px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 51, 'text', `Rsl[${constants.OCRGRP_START4 + 51}]`, 3, '')}<span>歳　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 52, 'radio', 'opt4_9_3_2', 0, '1')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 52, 'radio', 'opt4_9_3_2', 0, '2')}<span>他院　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea226(constants.OCRGRP_START4 + 50)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 53, 'checkbox', 'chk4_9_4', 0, '1')}<span>広汎子宮全摘術</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 54, 'text', `Rsl[${constants.OCRGRP_START4 + 54}]`, 3, '')}<span>歳　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 55, 'radio', 'opt4_9_4_1', 0, '1')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 55, 'radio', 'opt4_9_4_1', 0, '2')}<span>他院　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea229(constants.OCRGRP_START4 + 53)}
                {this.getLstResultArea230(constants.OCRGRP_START4 + 54)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 56, 'checkbox', 'chk4_9_5', 0, '1')}<span>子宮頸部円錐切除術</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 57, 'text', `Rsl[${constants.OCRGRP_START4 + 57}]`, 3, '')}<span>歳　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 58, 'radio', 'opt4_9_5_1', 0, '1')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 58, 'radio', 'opt4_9_5_1', 0, '2')}<span>他院　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea232(constants.OCRGRP_START4 + 56)}
                {this.getLstResultArea233(constants.OCRGRP_START4 + 57)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 59, 'checkbox', 'chk4_9_6', 0, '1')}<span>子宮筋腫核出術</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 60, 'text', `Rsl[${constants.OCRGRP_START4 + 60}]`, 3, '')}<span>歳　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 61, 'radio', 'opt4_9_6_1', 0, '1')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 61, 'radio', 'opt4_9_6_1', 0, '2')}<span>他院　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea235(constants.OCRGRP_START4 + 59)}
                {this.getLstResultArea236(constants.OCRGRP_START4 + 60)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 62, 'checkbox', 'chk4_9_7', 0, '1')}<span>子宮膣上部切断術（子宮頸部残存）</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 63, 'text', `Rsl[${constants.OCRGRP_START4 + 63}]`, 3, '')}<span>歳　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 64, 'radio', 'opt4_9_7_1', 0, '1')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 64, 'radio', 'opt4_9_7_1', 0, '2')}<span>他院　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea238(constants.OCRGRP_START4 + 62)}
                {this.getLstResultArea239(constants.OCRGRP_START4 + 63)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 65, 'checkbox', 'chk4_9_8', 0, '1')}<span>その他の手術</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 66, 'text', `Rsl[${constants.OCRGRP_START4 + 66}]`, 3, '')}<span>歳　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 67, 'radio', 'opt4_9_8_1', 0, '1')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 67, 'radio', 'opt4_9_8_1', 0, '2')}<span>他院　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea241(constants.OCRGRP_START4 + 65)}
                {this.getLstResultArea242(constants.OCRGRP_START4 + 66)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>10.性体験は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 68, 'radio', 'opt4_10_1', 0, '1')}<span>ない　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 68, 'radio', 'opt4_10_1', 0, '2')}<span>ある</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea244(constants.OCRGRP_START4 + 68)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>11．妊娠している可能性は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 69, 'radio', 'opt4_11_1', 0, '1')}<span>ない　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 69, 'radio', 'opt4_11_1', 0, '2')}<span>ある</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea245(constants.OCRGRP_START4 + 69)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>12．妊娠分娩</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  <span>　　妊娠の回数</span>{this.editRsl(constants.OCRGRP_START4 + 70, 'text', `Rsl[${constants.OCRGRP_START4 + 70}]`, 3, '')}<span>回</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea246no1(constants.OCRGRP_START4 + 70)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  <span>　　分娩の回数</span>
                  {this.editRsl(constants.OCRGRP_START4 + 71, 'text', `Rsl[${constants.OCRGRP_START4 + 71}]`, 3, '')}
                  <span>回（そのうち帝王切開</span>
                  {this.editRsl(constants.OCRGRP_START4 + 72, 'text', `Rsl[${constants.OCRGRP_START4 + 72}]`, 3, '')}
                  <span>回）</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea246no2(constants.OCRGRP_START4 + 70)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>13．閉経しましたか</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 73, 'radio', 'opt4_13_1', 0, '1')}<span>いいえ</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea249no1(constants.OCRGRP_START4 + 73)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 73, 'radio', 'opt4_13_1', 0, '2')}<span>はい</span>
                  {this.editRsl(constants.OCRGRP_START4 + 74, 'text', `Rsl[${constants.OCRGRP_START4 + 74}]`, 3, '')}<span>歳</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea249no2(constants.OCRGRP_START4 + 73)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>14．月経</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '24px', width: '120px' }}>
                  <span>①最終月経</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 75, 'listdate', 'date14_1', 0, '')}
                  <span>～</span>
                  {this.editRsl(constants.OCRGRP_START4 + 78, 'listdate', 'date14_2', 0, '')}
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea251256(constants.OCRGRP_START4 + 75)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '24px', width: '120px' }}>
                  <span>②その前の月経</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 80, 'listdate', 'date14_3', 0, '')}
                  <span>～</span>
                  {this.editRsl(constants.OCRGRP_START4 + 83, 'listdate', 'date14_4', 0, '')}
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea251256(constants.OCRGRP_START4 + 80)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '24px', width: '100px' }}>
                  <span>③出血量</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 85, 'radio', 'opt4_14_1', 0, '1')}<span>少ない　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 85, 'radio', 'opt4_14_1', 0, '2')}<span>ふつう　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 85, 'radio', 'opt4_14_1', 0, '3')}<span>多い</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea261(constants.OCRGRP_START4 + 85)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '24px', width: '100px' }}>
                  <span>④月経痛</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 86, 'radio', 'opt4_14_2', 0, '4')}<span>軽い　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 86, 'radio', 'opt4_14_2', 0, '5')}<span>ふつう　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 86, 'radio', 'opt4_14_2', 0, '6')}<span>強い　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea262(constants.OCRGRP_START4 + 86)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>15．6ヶ月以内に月経以外に出血したことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 87, 'radio', 'opt4_15_1', 0, '1')}<span>ない</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea263no1(constants.OCRGRP_START4 + 87)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 87, 'radio', 'opt4_15_1', 0, '4')}<span>ある　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 88, 'radio', 'opt4_15_2', 0, '1')}<span>閉経後出血　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 88, 'radio', 'opt4_15_2', 0, '2')}<span>性交時出血　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 88, 'radio', 'opt4_15_2', 0, '3')}<span>その他の出血　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea263no2(constants.OCRGRP_START4 + 87)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>16．その他気になる症状はありますか</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 89, 'radio', 'opt4_16_1', 0, '1')}<span>ない</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea265no1(constants.OCRGRP_START4 + 89)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 89, 'radio', 'opt4_16_1', 0, '10')}<span>ある　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 90, 'checkbox', 'chk4_16_1', 0, '1')}<span>下腹部痛（月経痛以外で）　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 91, 'checkbox', 'chk4_16_2', 0, '1')}<span>おりもの（水様性）　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 92, 'checkbox', 'chk4_16_3', 0, '1')}<span>おりもの（血液、茶色含む）</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea265no2(constants.OCRGRP_START4 + 89)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>17.ご家族で婦人科系のガンにかかられた方は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 93, 'radio', 'opt4_17_1', 0, '1')}<span>いない　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 93, 'radio', 'opt4_17_1', 0, '10')}<span>いる　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea269(constants.OCRGRP_START4 + 93)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '0px' }}>
                  <span>　　「はい」の場合</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 94, 'checkbox', 'chk4_17_1', 0, '1')}<span>子宮頸がん</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 95, 'checkbox', 'chk4_17_2', 0, '1')}<span>実母　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 96, 'checkbox', 'chk4_17_3', 0, '2')}<span>実姉妹　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 97, 'checkbox', 'chk4_17_4', 0, '3')}<span>その他血縁　　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea270(constants.OCRGRP_START4 + 94)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 98, 'checkbox', 'chk4_17_5', 0, '5')}<span>子宮体がん</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 99, 'checkbox', 'chk4_17_6', 0, '1')}<span>実母　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 100, 'checkbox', 'chk4_17_7', 0, '2')}<span>実姉妹　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 101, 'checkbox', 'chk4_17_8', 0, '3')}<span>その他血縁　　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea274(constants.OCRGRP_START4 + 98)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 102, 'checkbox', 'chk4_17_9', 0, '7')}<span>卵巣がん</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 103, 'checkbox', 'chk4_17_10', 0, '1')}<span>実母　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 104, 'checkbox', 'chk4_17_11', 0, '2')}<span>実姉妹　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 105, 'checkbox', 'chk4_17_12', 0, '3')}<span>その他血縁　　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea278(constants.OCRGRP_START4 + 102)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 106, 'checkbox', 'chk4_17_13', 0, '9')}<span>その他の婦人科がん</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 107, 'checkbox', 'chk4_17_14', 0, '1')}<span>実母　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 108, 'checkbox', 'chk4_17_15', 0, '2')}<span>実姉妹　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 109, 'checkbox', 'chk4_17_16', 0, '3')}<span>その他血縁　　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea282(constants.OCRGRP_START4 + 106)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '280px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 110, 'checkbox', 'chk4_17_17', 0, '8')}<span>乳がん</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 111, 'checkbox', 'chk4_17_18', 0, '1')}<span>実母　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 112, 'checkbox', 'chk4_17_19', 0, '2')}<span>実姉妹　　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 113, 'checkbox', 'chk4_17_20', 0, '3')}<span>その他血縁　　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea286(constants.OCRGRP_START4 + 110)}
              </div>
              <div style={{ clear: 'left' }} />
            </div>
          }

          {/* ****************************************************** */}
          {/*     食習慣問診                                         */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98fb98', marginTop: '3px' }}>
            <span id="Anchor-Syokusyukan" style={{ position: 'relative' }}>食習慣問診票</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98fb98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '0px' }}>
              {this.editRsl(constants.OCRGRP_START5, 'checkbox', 'chk5_1', 0, '1')}<span style={{ fontWeight: 'bold' }}>本人希望により未回答</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>１．摂取エネルギーについて</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　カロリー制限を受けていますか</span>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '37px' }}>
              <div style={{ float: 'left', height: '28px', width: '120px', marginTop: '2px', marginLeft: '2px' }}>
                {this.editRsl(constants.OCRGRP_START5 + 1, 'radio', 'opt5_1', 0, '1')}<span>はい </span>
              </div>
              <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
                {this.editRsl(constants.OCRGRP_START5 + 2, 'text', `Rsl[${constants.OCRGRP_START5 + 2}]`, 5, '')}<span>kcal </span>
              </div>
              <div style={{ float: 'left', height: '28px', width: '130px', marginTop: '2px', marginLeft: '2px' }}>
                {this.editRsl(constants.OCRGRP_START5 + 1, 'radio', 'opt5_1', 0, '2')}<span>いいえ </span>
              </div>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>２．食習慣に当てはまるもの</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>1)食事の速度は速いほうですか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 3, 'radio', 'opt5_2_1', 0, '1')}<span>速いほうである</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 3, 'radio', 'opt5_2_1', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>2)満腹になるまで食べるほうですか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 4, 'radio', 'opt5_2_2', 0, '1')}<span>そうである</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 4, 'radio', 'opt5_2_2', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>3)食事の規則性は</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 5, 'radio', 'opt5_2_3', 0, '1')}<span>規則正しい</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 5, 'radio', 'opt5_2_3', 0, '2')}<span>それほどでもない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '240px', marginTop: '2px', marginLeft: '2px' }}>
              <span>（１週間の平均欠食回数</span>{this.editRsl(constants.OCRGRP_START5 + 6, 'text', `Rsl[${constants.OCRGRP_START5 + 6}]`, 2, '')}<span>回）</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>4)バランスを考えて食べていますか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 7, 'radio', 'opt5_2_4', 0, '1')}<span>考えている</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 7, 'radio', 'opt5_2_4', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>5)甘いものはよく食べますか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 8, 'radio', 'opt5_2_5', 0, '1')}<span>よく食べる</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 8, 'radio', 'opt5_2_5', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>6)脂肪分の多い食事は好んで食べますか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 9, 'radio', 'opt5_2_6', 0, '1')}<span>好んで食べる</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 9, 'radio', 'opt5_2_6', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>7)味付けは濃いほうですか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 10, 'radio', 'opt5_2_7', 0, '1')}<span>濃い方である</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 10, 'radio', 'opt5_2_7', 0, '2')}<span>ふつう</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 10, 'radio', 'opt5_2_7', 0, '3')}<span>薄味にしている</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>8)間食をとることがありますか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 11, 'radio', 'opt5_2_8', 0, '1')}<span>食べない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 11, 'radio', 'opt5_2_8', 0, '2')}<span>食べる</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '240px', marginTop: '2px', marginLeft: '2px' }}>
              <span>（１週間の平均欠食回数</span>{this.editRsl(constants.OCRGRP_START5 + 12, 'text', `Rsl[${constants.OCRGRP_START5 + 12}]`, 2, '')}<span>回）</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '320px', marginTop: '2px' }}>
              <span>9)減塩醤油はお使いですか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 13, 'radio', 'opt5_2_9', 0, '1')}<span>使っている</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 13, 'radio', 'opt5_2_9', 0, '2')}<span>使っていない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>３．１日の嗜好品摂取量</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>コーヒー・紅茶</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 14, 'text', `Rsl[${constants.OCRGRP_START5 + 14}]`, 2, '')}<span>杯</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>あめ</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 23, 'text', `Rsl[${constants.OCRGRP_START5 + 23}]`, 2, '')}<span>個</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>　砂糖（小さじ）</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 15, 'text', `Rsl[${constants.OCRGRP_START5 + 15}]`, 2, '')}<span>片</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>チョコレート</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 24, 'text', `Rsl[${constants.OCRGRP_START5 + 24}]`, 2, '')}<span>杯</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>　ミルク（小さじ）</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 16, 'text', `Rsl[${constants.OCRGRP_START5 + 16}]`, 2, '')}<span>杯</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>スナック菓子</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 25, 'text', `Rsl[${constants.OCRGRP_START5 + 25}]`, 2, '')}<span>皿</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>ジュース（スポーツ飲料も含む）</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 17, 'text', `Rsl[${constants.OCRGRP_START5 + 17}]`, 2, '')}<span>00ml</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>ナッツ</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '160px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 26, 'text', `Rsl[${constants.OCRGRP_START5 + 26}]`, 2, '')}<span>皿（ひとつかみ）</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>果汁・野菜ジュース</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 18, 'text', `Rsl[${constants.OCRGRP_START5 + 18}]`, 2, '')}<span>00ml</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>和菓子（まんじゅうなど）</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 27, 'text', `Rsl[${constants.OCRGRP_START5 + 27}]`, 2, '')}<span>個</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>炭酸飲料</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 19, 'text', `Rsl[${constants.OCRGRP_START5 + 19}]`, 2, '')}<span>00ml</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>洋菓子（ケーキなど）</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 28, 'text', `Rsl[${constants.OCRGRP_START5 + 28}]`, 2, '')}<span>個</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>アイス</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 20, 'text', `Rsl[${constants.OCRGRP_START5 + 20}]`, 2, '')}<span>個</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>ドーナツ</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 29, 'text', `Rsl[${constants.OCRGRP_START5 + 29}]`, 2, '')}<span>個</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>シャーベット</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 21, 'text', `Rsl[${constants.OCRGRP_START5 + 21}]`, 2, '')}<span>個</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>ゼリー</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 30, 'text', `Rsl[${constants.OCRGRP_START5 + 30}]`, 2, '')}<span>個</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>クッキー</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 22, 'text', `Rsl[${constants.OCRGRP_START5 + 22}]`, 2, '')}<span>個</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>せんべい（あられ）</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 31, 'text', `Rsl[${constants.OCRGRP_START5 + 31}]`, 2, '')}<span>枚（ひとつかみ）</span>
            </div>
          </div>

          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>４．乳製品の１日摂取量</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '120px', marginTop: '2px' }}>
              <span>普通牛乳</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 32, 'text', `Rsl[${constants.OCRGRP_START5 + 32}]`, 2, '')}<span>00ml</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '120px', marginTop: '2px' }}>
              <span>低脂肪牛乳</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 34, 'text', `Rsl[${constants.OCRGRP_START5 + 34}]`, 2, '')}<span>00ml</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '120px', marginTop: '2px' }}>
              <span>普通ヨーグルト</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 33, 'text', `Rsl[${constants.OCRGRP_START5 + 33}]`, 2, '')}<span>00ml</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '120px', marginTop: '2px' }}>
              <span>低脂肪ヨーグルト</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 35, 'text', `Rsl[${constants.OCRGRP_START5 + 35}]`, 2, '')}<span>00ml</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />
          {/* ****************************************************** */}
          {/*     朝食                                               */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98FB98', marginTop: '2px' }}>
            <span id="Anchor-Morning">朝食について</span>
          </div>

          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98FB98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）毎日食べていますか</span>
          </div>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '55px' }}>
              {this.editRsl(constants.OCRGRP_START6, 'radio', 'opt6_1', 0, '1')}<span>食べる</span>
              {this.editRsl(constants.OCRGRP_START6, 'radio', 'opt6_1', 0, '2')}<span>時々食べる</span>
              {this.editRsl(constants.OCRGRP_START6, 'radio', 'opt6_1', 0, '3')}<span>食べない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            {this.editMenuList(constants.OCRGRP_START6)}
          </div>
          <div style={{ float: 'left', height: '20px', width: '1360px' }} />
          <div style={{ clear: 'left' }} />
          {/* ****************************************************** */}
          {/*     昼食                                               */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98FB98', marginTop: '2px' }}>
            <span id="Anchor-Lunch">昼食について</span>
          </div>

          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98FB98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）毎日食べていますか</span>
          </div>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '24px' }}>
              {this.editRsl(constants.OCRGRP_START7, 'radio', 'opt7_1', 0, '1')}<span>食べる</span>
              {this.editRsl(constants.OCRGRP_START7, 'radio', 'opt7_1', 0, '2')}<span>時々食べる</span>
              {this.editRsl(constants.OCRGRP_START7, 'radio', 'opt7_1', 0, '3')}<span>食べない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            {this.editMenuList(constants.OCRGRP_START7)}
          </div>
          <div style={{ float: 'left', height: '20px', width: '1360px' }} />
          <div style={{ clear: 'left' }} />
          {/* ****************************************************** */}
          {/*     夕食                                               */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98FB98', marginTop: '2px' }}>
            <span id="Anchor-Dinner">夕食について</span>
          </div>

          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98FB98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）毎日食べていますか</span>
          </div>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '24px' }}>
              {this.editRsl(constants.OCRGRP_START8, 'radio', 'opt8_1', 0, '1')}<span>食べる</span>
              {this.editRsl(constants.OCRGRP_START8, 'radio', 'opt8_1', 0, '2')}<span>時々食べる</span>
              {this.editRsl(constants.OCRGRP_START8, 'radio', 'opt8_1', 0, '3')}<span>食べない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            {this.editMenuList(constants.OCRGRP_START8)}
          </div>
          <div style={{ float: 'left', height: '20px', width: '1360px' }} />
          <div style={{ clear: 'left' }} />
          {/* ****************************************************** */}
          {/*     特定健診                                           */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98fb98', marginTop: '2px' }}>
            <span id="Anchor-Special" style={{ position: 'relative' }}>特定健診問診票</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98fb98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>運動や食生活等の生活習慣を改善してみようと思いますか</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '168px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '168px', marginTop: '2px' }}>
              {this.editRsl(constants.OCRGRP_START9, 'radio', 'opt9_1', 0, '1')}<span>①改善するつもりはない</span><br />
              {this.editRsl(constants.OCRGRP_START9, 'radio', 'opt9_1', 0, '2')}<span>②改善するつもりである（概ね6ヶ月以内）</span><br />
              {this.editRsl(constants.OCRGRP_START9, 'radio', 'opt9_1', 0, '3')}<span>③近いうちに（概ね1ヶ月以内）改善するつもりであり、少しずつはじめている</span><br />
              {this.editRsl(constants.OCRGRP_START9, 'radio', 'opt9_1', 0, '4')}<span>④既に改善に取り組んでいる（6ヶ月未満）</span><br />
              {this.editRsl(constants.OCRGRP_START9, 'radio', 'opt9_1', 0, '5')}<span>⑤既に改善に取り組んでいる（6ヶ月以上）</span><br />
              {this.editRsl(constants.OCRGRP_START9, 'radio', 'opt9_1', 0, '6')}<span>未回答</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea575(constants.OCRGRP_START9)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>生活習慣の改善について保健指導を受ける機会があれば、利用しますか</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', marginTop: '2px' }}>
              {this.editRsl(constants.OCRGRP_START9 + 1, 'radio', 'opt9_2', 0, '1')}<span>①はい</span>
              {this.editRsl(constants.OCRGRP_START9 + 1, 'radio', 'opt9_2', 0, '2')}<span>②いいえ</span>
              {this.editRsl(constants.OCRGRP_START9 + 1, 'radio', 'opt9_2', 0, '3')}<span>未回答</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea576(constants.OCRGRP_START9 + 1)}
          </div>
          <div style={{ clear: 'left' }} />

          {/* ****************************************************** */}
          {/*     OCR入力担当者                                      */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', marginTop: '30px' }} >
            <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
            <div style={{ float: 'left', height: '20px', marginTop: '2px', marginRight: '10px' }}>
              <span id="Anchor-Operator" style={{ position: 'relative' }}>OCR入力担当者</span>
            </div>
            <div style={{ float: 'left', height: '20px', marginTop: '2px', marginRight: '5px' }}>
              <SentenceGuide setChgRsl={(index, result) => this.setChgRsl(index, result)} />
            </div>
            <div style={{ float: 'left', height: '20px', marginTop: '2px', marginRight: '10px' }}>
              <a role="presentation" style={{ cursor: 'pointer' }} onClick={() => this.clrUser(constants.OCRGRP_START10 + 0)}><span style={{ color: 'red' }}>X</span></a>
            </div>
            <div style={{ float: 'left', height: '20px', marginTop: '2px', marginRight: '3px' }}>
              <span id="OpeName">{strOpeNameStc}</span>
            </div>
            <div style={{ clear: 'left' }} />
          </div>
          <div style={{ clear: 'left' }} />
        </div>
      </div>
    );
  }
}

// propTypesの定義
OcrNyuryokuSpBody2.propTypes = {
  rsvno: PropTypes.string.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  consult: PropTypes.shape().isRequired,
  perResultGrp: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  ocrNyuryoku: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  chgRsl: PropTypes.arrayOf(PropTypes.shape()),
  setValue: PropTypes.func.isRequired,
  strOpeNameStc: PropTypes.string,
  act: PropTypes.string,
  lngErrCntE: PropTypes.number,
  lngErrCntW: PropTypes.number,
  getInstance: PropTypes.func.isRequired,
};

OcrNyuryokuSpBody2.defaultProps = {
  chgRsl: [],
  strOpeNameStc: '',
  act: '',
  lngErrCntE: 0,
  lngErrCntW: 0,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const selector = formValueSelector(formName);
  return {
    message: state.app.dailywork.questionnaire2.ocrNyuryokuSpBody2.message,
    consult: state.app.dailywork.questionnaire2.ocrNyuryokuSpBody2.consult,
    perResultGrp: state.app.dailywork.questionnaire2.ocrNyuryokuSpBody2.perResultGrp,
    ocrNyuryoku: state.app.dailywork.questionnaire2.ocrNyuryokuSpBody2.ocrNyuryoku,
    checkOcrNyuryoku: state.app.dailywork.questionnaire2.ocrNyuryokuSpBody2.checkOcrNyuryoku,
    chgRsl: selector(state, 'chgRsl'),
    strOpeNameStc: selector(state, 'strOpeNameStc'),
    act: selector(state, 'act'),
    lngErrCntE: selector(state, 'lngErrCntE'),
    lngErrCntW: selector(state, 'lngErrCntW'),
  };
};

const mapDispatchToProps = (dispatch) => ({
  // OCR入力結果確認（ボディ）情報取得
  onLoad: (conditions) => {
    // 指定対象受診者の検査結果を抽出する
    dispatch(getOcrNyuryokuSpBody2Request(conditions));
  },
  // OCR入力結果保存
  onSave: (conditions) => {
    // 指定対象受診者の検査結果を抽出する
    dispatch(getOcrNyuryokuSpBody2Request(conditions));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OcrNyuryokuSpBody2);
