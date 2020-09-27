import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import { Field, blur, formValueSelector } from 'redux-form';

import MessageBanner from '../../components/MessageBanner';
import DropDown from '../../components/control/dropdown/DropDown';
import DatePicker from '../../components/control/datepicker/DatePicker';
import SentenceGuide from './SentenceGuide';

import { getOcrNyuryokuBodyRequest } from '../../modules/dailywork/questionnaireModule';

import { OcrNyuryokuBody } from '../../constants/common';

const constants = OcrNyuryokuBody.OcrNyuryokuBody;

// コード(病名)
const strArrCode1 = [
  '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
  '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
  '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
  '31', '32', '33', '34', '35', '36', '37', '38', '39', '40',
  '41', '42', '43', '44', '45', '46', '47', '48', '49', '50',
  '51', '52', '53', '54', '55',
  '98', '99',
  '101', '102', '103', '104', '105', '106', '107', '108', '109',
  '201', '202', '203', '204', '205', '206', '207', '208', '209', '210',
  '211', '212', '213', '214', '215', '216', '217',
  'XXX'];

// 名称(病名)
const strArrName1 = [
  '脳腫瘍', '脳梗塞', 'クモ膜下出血', '脳出血', '一過性脳虚血発作', '緑内障', '白内障', '糖尿病網膜症', 'その他の眼科疾患', '甲状腺機能低下症',
  '甲状腺機能亢進症', '結核・胸膜炎', '肺がん', '肺線維症', '肺気腫', '気管支ぜんそく', '気管支拡張症', '慢性気管支炎', '高血圧', '狭心症',
  '心筋梗塞', '心房中隔欠損症', '心室中隔欠損症', '心臓弁膜症', '不整脈', '食道がん', '胃がん', '胃潰瘍', '胃ポリープ', '十二指腸潰瘍',
  '大腸がん', '大腸ポリープ', '虫垂炎', '痔', '胆石症', '胆のうポリープ', '慢性膵炎', '肝がん', 'Ｂ型肝炎', 'Ｃ型肝炎',
  '肝硬変', '腎炎・ネフローゼ', '腎結石', '尿路結石', '前立腺がん', '前立腺肥大', '脂質異常症（高脂血症）', '糖尿病', '血液疾患', '貧血',
  '痛風・高尿酸血症', '神経症', 'うつ病', '扁桃腺炎', '慢性腎不全',
  'その他', 'その他のがん',
  '子宮頚がん', '子宮体がん', '卵巣嚢腫（腫瘍）', '子宮内膜症', '子宮筋腫', '子宮細胞診異常', '乳がん', '乳腺症', '更年期障害',
  '甲状腺疾患', '膠原病', '急性膵炎', '大動脈瘤', '腸閉塞', '腎不全', '前立腺ＰＳＡ高値', 'その他の心疾患', 'その他の神経筋疾患', 'その他の上部消化管疾患',
  'その他の大腸疾患', 'その他の肝疾患', 'その他の前立腺疾患', 'その他の乳房疾患', '皮膚科疾患', '耳鼻科疾患', '整形外科疾患',
  '※入力異常'];

// コード(治療状況)
const strArrCode2 = [
  '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', 'XXX'];

// 名称(治療状況)
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
  '※入力異常'];

// コード(続柄)
const strArrCode3 = ['1', '2', '3', '4', 'XXX'];

// 名称(続柄)
const strArrName3 = ['父親', '母親', '兄弟・姉妹', '祖父母', '※入力異常'];

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

const subTitles = ['ご飯（女性用茶碗）', 'ご飯（男性用茶碗）', 'ご飯（どんぶり茶碗）', 'おにぎり',
  'そば・うどん（天ぷら）', 'そば・うどん（たぬき）', 'そば・うどん（ざる・かけ）', 'ラーメン', '五目ラーメン', '焼きそば', 'スパゲッティ（クリーム）', 'スパゲッティ（その他）', 'マカロニグラタン',
  '食パン６枚切り', '食パン８枚切り', '　バター', '　マーガリン', '　ジャム類', 'ミックスサンドイッチ', '菓子パン', '調理パン',
  'カツ丼', '親子丼', '天丼', '中華丼', 'カレーライス', 'チャーハン・ピラフ', 'にぎり・ちらし寿司',
  '幕の内弁当', 'シリアル等', 'ミックスピザ',
  '刺身盛り合わせ', '煮魚・焼魚（ぶり、さんま、いわし等）', '煮魚・焼魚（かれい、たら、ひらめ等）', '魚のムニエル', 'エビチリ', '八宝菜',
  'ステーキ(150g)', '焼き肉', 'とりの唐揚', 'ハンバーグ', 'シチュー', '肉野菜炒め', '餃子・シュウマイ', 'ハム・ウィンナー', 'ベーコン',
  'フライ（コロッケ）', 'フライ（トンカツ）', 'フライ（えび）', '天ぷら',
  'すき焼き・しゃぶしゃぶ等', '寄鍋・たらちり等', 'おでん',
  '生卵・ゆで卵', '目玉焼き', '卵焼き', 'スクランブル', 'かに玉',
  '冷・湯豆腐', '納豆', 'マーボ豆腐', '五目豆',
  '野菜サラダ', '　ノンオイルドレッシング', '　マヨネーズ', '　ドレッシング', '　塩', 'ポテト・マカロニサラダ', '煮物（芋入り）', '煮物（野菜のみ）', '煮物（ひじき・昆布等）', '肉じゃが', '野菜炒め（肉なし）', 'おひたし', '酢の物',
  '味噌汁', 'コンソメ', 'ポタージュ',
  'チーズ', '枝豆', '果物', 'お漬物'];

const subUnits = ['杯', '杯', '杯', '個',
  '杯', '杯', '杯', '杯', '杯', '皿', '人前', '人前', '人前',
  '枚', '枚', '杯', '杯', '杯', '人前', '個', '個',
  '杯', '杯', '杯', '杯', '人前', '人前', '人前',
  '人前', '皿', '人前',
  '人前', '人前', '人前', '人前', '人前', '人前',
  '人前', '人前', '人前', '人前', '人前', '人前', '人前', '枚', '枚',
  '人前', '人前', '人前', '人前',
  '人前', '人前', '人前',
  '個', '個', '個', '個', '個',
  '人前', '個', '人前', '人前',
  '皿', '杯', '杯', '杯', 'つまみ', '人前', '人前', '人前', '人前', '人前', '人前', '人前', '人前',
  '杯', '杯', '杯',
  '個', '個', '個', '人前'];

const nowDivWidth = 900;
const nowDivWidth2 = 1000;
const nowDivWidth3 = 1200;
const lstDivWidth = 200;

const formName = 'OcrNyuryoku';

let errInfoNo = 0;
class ocrNyuryokuBody extends React.Component {
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
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { act, lngErrCntE, lngErrCntW, setValue } = nextProps;

    this.onBodyLoad(nextProps);

    if (act && act === 'check'
      && lngErrCntE === 0 && lngErrCntW > 0) {
      setValue('act', '');
      setValue('lngErrCntE', 0);
      setValue('lngErrCntW', 0);
      if (confirm('警告がありますが、このまま保存しますか？')) {
        // モードを指定してsubmit
        this.save('save');
      }
    }
  }

  onBodyLoad = (nextProps) => {
    const { errInfo } = nextProps;
    if (!errInfo) {
      return;
    }
    const { errState, errMessage, errNo, errCount } = errInfo;

    let i = 0;
    let strHtml;
    let elementId;

    for (i = 1; i <= errInfoNo; i += 1) {
      // マークを表示
      elementId = `Anchor-ErrInfo${i}`;
      if (document.all && document.all(elementId)) {
        document.all(elementId).innerHTML = '';
      } else if (document.getElementById && document.getElementById(elementId)) {
        document.getElementById(elementId).innerHTML = '';
      }
    }
    if (errCount && errCount > 0) {
      for (i = 0; i < errCount; i += 1) {
        if (errNo[i] > 0) {
          switch (errState[i]) {
            case '1': // エラー
              strHtml = `<div style="border: 2px red solid; margin-right: 3px; height: 26px;"><span title=${errMessage[i]} style="color: red; font-weight: bold;">E</span></div>`;
              break;
            case '2': // 警告
              strHtml = `<div style="border: 2px orange solid; margin-right: 3px; height: 26px;"><span title=${errMessage[i]} style="color: orange; font-weight: bold;">I</span></div>`;
              break;
            default: break;
          }

          // マークを表示
          elementId = `Anchor-ErrInfo${errNo[i]}`;
          if (document.all && document.all(elementId)) {
            document.all(elementId).innerHTML = strHtml;
          } else if (document.getElementById && document.getElementById(elementId)) {
            document.getElementById(elementId).innerHTML = strHtml;
          }
        }
      }
    }
  }

  // 前回値
  getLstCslDate = (ocrNyuryoku) => {
    if (ocrNyuryoku.ocrresult
      && ocrNyuryoku.ocrresult.length > 0
      && ocrNyuryoku.ocrresult[0].lstcsldate
      && ocrNyuryoku.ocrresult[0].lstcsldate !== '') {
      return `(${moment(ocrNyuryoku.ocrresult[0].lstcsldate).format('M/D/YYYY')})`;
    }

    return '';
  }

  // 今回値
  getResultArea0 = (lngIndex) => {
    const { ocrNyuryoku, perResultGrp } = this.props;
    if (perResultGrp && perResultGrp.length > 0 && perResultGrp[0].result === '2') {
      ocrNyuryoku.ocrresult[lngIndex].result = '2';
      return (
        <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
          <span>　　可　　　</span>{this.editRsl(lngIndex, 'radio', 'opt1_1', 0, '2')}<span>否</span>
        </div>
      );
    }

    return (
      <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
        {this.editRsl(lngIndex, 'radio', 'opt1_1', 0, '1')}<span>可　　　</span>
        {this.editRsl(lngIndex, 'radio', 'opt1_1', 0, '2')}<span>否</span>
      </div>
    );
  }

  // 前回値
  getLstResultArea0 = (lngIndex) => {
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
  getLstResultArea1 = (lngIndex) => {
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
  getLstResultArea56 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>胃全摘手術</span>); break;
        case '2': strLstRsl.push(<span>胃部分切除</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea57 = (lngIndex) => {
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
  getLstResultArea58 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult
        && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 肺結核</span>);
        } else {
          strLstRsl.push(<span>肺結核</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 無気肺</span>);
        } else {
          strLstRsl.push(<span>無気肺</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 肺腺維症</span>);
        } else {
          strLstRsl.push(<span>肺腺維症</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 胸膜瘢痕</span>);
        } else {
          strLstRsl.push(<span>胸膜瘢痕</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 4].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 陳旧性病変</span>);
        } else {
          strLstRsl.push(<span>陳旧性病変</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea63 = (lngIndex) => {
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
          strLstRsl.push(<span>, 胃新生物</span>);
        } else {
          strLstRsl.push(<span>胃新生物</span>);
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
  getLstResultArea70 = (lngIndex) => {
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
      if (ocrNyuryoku.ocrresult[lngIndex + 6].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 6].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 腎嚢胞</span>);
        } else {
          strLstRsl.push(<span>腎嚢胞</span>);
        }
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 7].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 7].lstresult !== '') {
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
  getLstResultArea73 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex + 5].lstresult
        && ocrNyuryoku.ocrresult[lngIndex + 5].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, 腎結石</span>);
        } else {
          strLstRsl.push(<span>腎結石</span>);
        }
      }
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
  getLstResultArea78 = (lngIndex) => {
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
          strLstRsl.push(<span>, その他</span>);
        } else {
          strLstRsl.push(<span>その他</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea83 = (lngIndex) => {
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
  getLstResultArea86 = (lngIndex) => {
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
  getLstResultArea87 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>2ｋｇ以上増加した</span>); break;
        case '2': strLstRsl.push(<span>変動なし</span>); break;
        case '3': strLstRsl.push(<span>2ｋｇ以上減少した</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea88 = (lngIndex) => {
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
  getLstResultArea90 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}</span>);
        switch (lngIndex) {
          case 90: strLstRsl.push(<span>本（ビール大瓶）</span>); break;
          case 91: strLstRsl.push(<span>本（ビール３５０ml缶）</span>); break;
          case 92: strLstRsl.push(<span>本（ビール５００ml缶）</span>); break;
          case 93: strLstRsl.push(<span>本（日本酒）</span>); break;
          case 94: strLstRsl.push(<span>本（焼酎）</span>); break;
          case 95: strLstRsl.push(<span>本（ワイン）</span>); break;
          case 96: strLstRsl.push(<span>本（ウイスキー・ブランデー）</span>); break;
          case 97: strLstRsl.push(<span>本（その他）</span>); break;
          default: break;
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea98 = (lngIndex) => {
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
  getLstResultArea99 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}歳（吸い始めた年齢）</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}歳（やめた年齢）</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea101 = (lngIndex) => {
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
  getLstResultArea102 = (lngIndex) => {
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
  getLstResultArea103 = (lngIndex) => {
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
  getLstResultArea104 = (lngIndex) => {
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
  getLstResultArea105 = (lngIndex) => {
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
  getLstResultArea106 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>はい</span>); break;
        case '2': strLstRsl.push(<span>寝不足を感じる</span>); break;
        default: break;
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`睡眠時間（${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}時間）`}</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`就寝時刻（${ocrNyuryoku.ocrresult[lngIndex + 2].lstresult}時）`}</span>);
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
        case '1': strLstRsl.push(<span>毎食後に磨く</span>); break;
        case '2': strLstRsl.push(<span>１日１回は磨く</span>); break;
        case '3': strLstRsl.push(<span>１回も磨かない</span>); break;
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
  getLstResultArea111 = (lngIndex) => {
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
  getLstResultArea112 = (lngIndex) => {
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
  getLstResultArea113 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}分（片道の通勤時間）`}</span>);
      }

      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}分（片道の歩行時間）`}</span>);
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
        case '1': strLstRsl.push(<span>あり</span>); break;
        case '2': strLstRsl.push(<span>なし</span>); break;
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
      // 親 OCRGRP_START2 + 30
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex].lstresult}親`}</span>);
      }

      // 配偶者 OCRGRP_START2 + 31
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}配偶者`}</span>);
      }

      // 子供 OCRGRP_START2 + 32
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 2].lstresult}子供`}</span>);
      }

      // 独居 OCRGRP_START2 + 33
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 3].lstresult}独居`}</span>);
      }

      // その他 OCRGRP_START2 + 34
      if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult && ocrNyuryoku.ocrresult[lngIndex + 4].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 4].lstresult}その他`}</span>);
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
  getLstResultArea122 = (lngIndex) => {
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
  getLstResultArea123 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>ある</span>); break;
        case '2': strLstRsl.push(<span>ややある</span>); break;
        case '3': strLstRsl.push(<span>ほとんどない</span>); break;
        case '4': strLstRsl.push(<span>まったくない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea124 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>やっている</span>); break;
        case '2': strLstRsl.push(<span>やったことがある</span>); break;
        case '3': strLstRsl.push(<span>やりたいと思う</span>); break;
        case '4': strLstRsl.push(<span>やりたくない</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea149 = (lngIndex) => {
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
  getLstResultArea161 = (lngIndex) => {
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
  getLstResultArea162 = (lngIndex) => {
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
  getLstResultArea174 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>6ケ月以内</span>); break;
        case '2': strLstRsl.push(<span>6ケ月～1年以内</span>); break;
        case '3': strLstRsl.push(<span>1～2年以内</span>); break;
        case '4': strLstRsl.push(<span>3年前以上</span>); break;
        case '5': strLstRsl.push(<span>受けたことなし</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea175 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>当院</span>); break;
        case '2': strLstRsl.push(<span>他集団検診</span>); break;
        case '3': strLstRsl.push(<span>他医院・他病院</span>); break;
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
        case '1': strLstRsl.push(<span>異常なし</span>); break;
        case '2': strLstRsl.push(<span>異常あり（異型上皮）</span>); break;
        case '3': strLstRsl.push(<span>異常あり</span>); break;
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
        strLstRsl.push(<span>膣炎</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>月経異常</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>不妊</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult && ocrNyuryoku.ocrresult[lngIndex + 4].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮筋腫</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 5].lstresult && ocrNyuryoku.ocrresult[lngIndex + 5].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮内膜症</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 6].lstresult && ocrNyuryoku.ocrresult[lngIndex + 6].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮がん</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 7].lstresult && ocrNyuryoku.ocrresult[lngIndex + 7].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>子宮頚管ポリープ</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea185 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>卵巣腫瘍（右）</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>卵巣腫瘍（左）</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>乳がん</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
        if (strLstRsl.length > 0) {
          strLstRsl.push(<span>, </span>);
        }
        strLstRsl.push(<span>びらん</span>);
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
        case '1': strLstRsl.push(<span>なし</span>); break;
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
  getLstResultArea192 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>なし</span>); break;
        case '2': strLstRsl.push(<span>ある</span>); break;
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
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>子宮全摘術</span>);
        if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
          strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}歳`}</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea195 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>卵巣摘出術</span>);
        if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
          strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}歳`}</span>);
        }
        if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
          switch (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult) {
            case '7': strLstRsl.push(<span>　右</span>); break;
            case '8': strLstRsl.push(<span>　左</span>); break;
            case '9': strLstRsl.push(<span>　両</span>); break;
            case '10': strLstRsl.push(<span>　部分切除</span>); break;
            default: break;
          }
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea198 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>子宮筋腫核出術</span>);
        if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
          strLstRsl.push(<span>&nbsp;&nbsp;{`${ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}歳`}</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea200 = (lngIndex) => {
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
  getLstResultArea201 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}回</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
        strLstRsl.push(<span>　（そのうち帝王切開は{ocrNyuryoku.ocrresult[lngIndex + 1].lstresult}回）</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea203 = (lngIndex) => {
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
  getLstResultArea204 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>いいえ</span>); break;
        case '2':
          strLstRsl.push(<span>はい→　</span>);
          if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
            strLstRsl.push(<span>{`${ocrNyuryoku.ocrresult[lngIndex + 1]}歳`}</span>);
          }
          break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea206 = (lngIndex) => {
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
  getLstResultArea216 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
        strLstRsl.push(<span>{ocrNyuryoku.ocrresult[lngIndex].lstresult}日</span>);
      }
      if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult === '1') {
        strLstRsl.push(<span>　不規則</span>);
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea220 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>少ない</span>); break;
        case '2': strLstRsl.push(<span>普通</span>); break;
        case '3': strLstRsl.push(<span>多い</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea221 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>ない、又は軽い痛み</span>); break;
        case '2': strLstRsl.push(<span>強い痛みが時々ある</span>); break;
        case '3': strLstRsl.push(<span>毎回ひどい痛みがある</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea222 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      switch (ocrNyuryoku.ocrresult[lngIndex].lstresult) {
        case '1': strLstRsl.push(<span>ない</span>); break;
        case '2': strLstRsl.push(<span>１年以内にある</span>); break;
        case '3': strLstRsl.push(<span>１年以上前にある</span>); break;
        default: break;
      }
    }
    return strLstRsl;
  }

  // 前回値
  getLstResultArea223 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (lngIndex === 54) {
        if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>性交時に出血する</span>);
        }
      } else {
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
          strLstRsl.push(<span>おりものが気になる</span>);
        }
        if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>陰部がかゆい</span>);
        }
        if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>下腹部が痛い</span>);
        }
        if (ocrNyuryoku.ocrresult[lngIndex + 4].lstresult && ocrNyuryoku.ocrresult[lngIndex + 4].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>更年期症状がつらい</span>);
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
  getLstResultArea230 = (lngIndex) => {
    const { ocrNyuryoku } = this.props;
    const strLstRsl = [];

    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      if (lngIndex === 56) {
        if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>いない</span>);
        }
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
          strLstRsl.push(<span>その他</span>);
        }
      } else {
        if (ocrNyuryoku.ocrresult[lngIndex].lstresult && ocrNyuryoku.ocrresult[lngIndex].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>子宮体ガン</span>);
        }
        if (ocrNyuryoku.ocrresult[lngIndex + 1].lstresult && ocrNyuryoku.ocrresult[lngIndex + 1].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>子宮頚ガン</span>);
        }
        if (ocrNyuryoku.ocrresult[lngIndex + 2].lstresult && ocrNyuryoku.ocrresult[lngIndex + 2].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>卵巣ガン</span>);
        }
        if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>乳がん</span>);
        }
        if (ocrNyuryoku.ocrresult[lngIndex + 3].lstresult && ocrNyuryoku.ocrresult[lngIndex + 3].lstresult !== '') {
          if (strLstRsl.length > 0) {
            strLstRsl.push(<span>, </span>);
          }
          strLstRsl.push(<span>その他の婦人科系ガン</span>);
        }
      }
    }
    return strLstRsl;
  }

  // 現病歴 １．
  getDisease1Area = () => {
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
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 2 + i * 3].result
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 2 + i * 3].result !== '') {
          // 同じ病名を検索
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 2 + i * 3].result === ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 2 + j * 3].lstresult) {
            // 年齢が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 3 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 3 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '年齢';
            }
            // 治療状態が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 4 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 4 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '治療状態';
            }
          }
        }
      }

      strLstRsl = '';
      for (j = 0; j < strArrCode1.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 2 + i * 3].lstresult === strArrCode1[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName1[j];
          break;
        }
      }
      strLstRsl += (strLstRsl === '' ? '' : ' ');
      strLstRsl += (!ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 3 + i * 3].lstresult
        || ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 3 + i * 3].lstresult === '' ? '' : `${ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 3 + i * 3].lstresult}才`);
      for (j = 0; j < strArrCode2.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 4 + i * 3].lstresult === strArrCode2[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName2[j];
          break;
        }
      }

      strDisease.push((
        <div key={`NOWDISEASE_${i}`}>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 2 + i * 3, 'disease', `list1_1_1[${i + 1}]`, 3, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '390px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 2 + i * 3, 'list1', `list1_1_1[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 3 + i * 3, 'text', `Rsl[${constants.OCRGRP_START1 + 3 + i * 3}]`, 3, '')}才
          </div>
          <div style={{ float: 'left', height: '28px', width: '240px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 4 + i * 3, 'list2', `list1_1_2[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '144px', marginTop: '2px', marginLeft: '2px' }}>
            {strLstDiffMsg !== '' && <span style={{ color: 'red', fontWeight: 'bold', fontSize: '10px' }}>※{ strLstDiffMsg }違い</span>}
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '2px', marginLeft: '2px' }}>
            {strLstRsl}
          </div>
          <div style={{ clear: 'left' }} />
        </div>
      ));
    }
    return strDisease;
  }

  // 既往歴 ２．
  getDisease2Area = () => {
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
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 20 + i * 3].result
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 20 + i * 3].result !== '') {
          // 同じ病名を検索
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 20 + i * 3].result === ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 20 + j * 3].lstresult) {
            // 年齢が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 21 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 21 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '年齢';
            }
            // 治療状態が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 22 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 22 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '治療状態';
            }
          }
        }
      }

      strLstRsl = '';
      for (j = 0; j < strArrCode1.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 20 + i * 3].lstresult === strArrCode1[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName1[j];
          break;
        }
      }
      strLstRsl += (strLstRsl === '' ? '' : ' ');
      strLstRsl += (!ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 21 + i * 3].lstresult
        || ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 21 + i * 3].lstresult === '' ? '' : `${ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 21 + i * 3].lstresult}才`);
      for (j = 0; j < strArrCode2.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 22 + i * 3].lstresult === strArrCode2[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName2[j];
          break;
        }
      }

      strDisease.push((
        <div key={`DISEASEHIST_${i}`}>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 20 + i * 3, 'disease', `list1_2_1[${i + 1}]`, 3, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '390px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 20 + i * 3, 'list1', `list1_2_1[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 21 + i * 3, 'text', `Rsl[${constants.OCRGRP_START1 + 21 + i * 3}]`, 3, '')}才
          </div>
          <div style={{ float: 'left', height: '28px', width: '240px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 22 + i * 3, 'list2', `list1_2_2[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '144px', marginTop: '2px', marginLeft: '2px' }}>
            {strLstDiffMsg !== '' && <span style={{ color: 'red', fontWeight: 'bold', fontSize: '10px' }}>※{ strLstDiffMsg }違い</span>}
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '2px', marginLeft: '2px' }}>
            {strLstRsl}
          </div>
          <div style={{ clear: 'left' }} />
        </div>
      ));
    }
    return strDisease;
  }

  // 家族歴 ３．
  getDisease3Area = () => {
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
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 38 + i * 3].result
          && ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 38 + i * 3].result !== '') {
          // 同じ病名を検索
          if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 38 + i * 3].result === ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 38 + j * 3].lstresult) {
            // 発症年齢が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 39 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 39 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '発症年齢';
            }
            // 続柄が違う
            if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 40 + i * 3].result !== ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 40 + j * 3].lstresult) {
              strLstDiffMsg += (strLstDiffMsg !== '' ? '、' : '');
              strLstDiffMsg += '続柄';
            }
          }
        }
      }

      strLstRsl = '';
      for (j = 0; j < strArrCode1.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 38 + i * 3].lstresult === strArrCode1[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName1[j];
          break;
        }
      }
      strLstRsl += (strLstRsl === '' ? '' : ' ');
      strLstRsl += (!ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 39 + i * 3].lstresult
        || ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 39 + i * 3].lstresult === '' ? '' : `${ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 39 + i * 3].lstresult}才`);
      for (j = 0; j < strArrCode3.length; j += 1) {
        if (ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 40 + i * 3].lstresult === strArrCode3[j]) {
          strLstRsl += (strLstRsl === '' ? '' : ' ');
          strLstRsl += strArrName3[j];
          break;
        }
      }

      strDisease.push((
        <div key={`FAMILYHIST_${i}`}>
          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 38 + i * 3, 'disease', `list1_3_1[${i + 1}]`, 3, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '390px', marginTop: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 38 + i * 3, 'list1', `list1_3_1[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '60px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 39 + i * 3, 'text', `Rsl[${constants.OCRGRP_START1 + 39 + i * 3}]`, 3, '')}才
          </div>
          <div style={{ float: 'left', height: '28px', width: '240px', marginTop: '2px', marginLeft: '2px' }}>
            {this.editRsl(constants.OCRGRP_START1 + 40 + i * 3, 'list3', `list1_3_2[${i + 1}]`, 0, '')}
          </div>
          <div style={{ float: 'left', height: '28px', width: '144px', marginTop: '2px', marginLeft: '2px' }}>
            {strLstDiffMsg !== '' && <span style={{ color: 'red', fontWeight: 'bold', fontSize: '10px' }}>※{ strLstDiffMsg }違い</span>}
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginTop: '2px', marginLeft: '2px' }}>
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
    const { chgRsl, ocrNyuryoku, setValue } = this.props;

    chgRsl[index] = {
      itemcd: ocrNyuryoku.ocrresult[index].itemcd,
      suffix: ocrNyuryoku.ocrresult[index].suffix,
      result,
      lstresult: ocrNyuryoku.ocrresult[index].lstresult,
      stopflg: ocrNyuryoku.ocrresult[index].stopflg,
    };
    setValue('chgRsl', chgRsl.slice(0));
  }

  editRslEvent = (e, vntIndex) => {
    if (vntIndex < constants.OCRGRP_START4 + 32 || vntIndex > constants.OCRGRP_START4 + 41) {
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

      if (vntIndex === constants.OCRGRP_START4 + 32 || vntIndex === constants.OCRGRP_START4 + 37) {
        this.setChgRsl(vntIndex, year);
        this.setChgRsl(vntIndex + 1, month);
        this.setChgRsl(vntIndex + 2, day);
      } else if (vntIndex === constants.OCRGRP_START4 + 35 || vntIndex === constants.OCRGRP_START4 + 40) {
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
    // エレメントタイプごとの処理分岐
    switch (e.target.type) {
      // チェックボックス
      case 'checkbox':
        if (e.target.checked) {
          this.setChgRsl(Index, e.target.value);
          // setValue(e.target.name, e.target.value);
          // 婦人科問診票のNo.7の「なし」のチェックが他の項目を選択した時に自動的に消える
          lngIndex = constants.OCRGRP_START4;
          if (Index >= lngIndex + 4 && Index <= lngIndex + 14) {
            this.setChgRsl(177, '');
          }
          if (Index >= lngIndex + 50 && Index <= lngIndex + 54) {
            this.setChgRsl(223, '');
          }
          if (Index >= lngIndex + 57 && Index <= lngIndex + 64) {
            this.setChgRsl(230, '');
          }
        } else {
          this.setChgRsl(Index, '');
        }
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

    if (!chgRsl || chgRsl.length === 0) {
      return null;
    }

    let blnSearchFlg;
    let i;

    let size;
    switch (vntSize) {
      case 1: size = 30; break;
      case 2: size = 40; break;
      case 3: size = 50; break;
      default: size = vntSize * 12; break;
    }

    switch (vntType) {
      // テキスト
      case 'text':
        return (
          <input
            type="text"
            name={vntName}
            maxLength="8"
            style={{ textAlign: 'right', width: `${size}px` }}
            value={chgRsl[vntIndex].result}
            onChange={(e) => this.editRslEvent(e, vntIndex)}
          />
        );
      // チェックボックス
      case 'checkbox':
        return (
          <input type="checkbox" name={vntName} value={vntOnValue} checked={this.getChecked(vntIndex, vntOnValue)} onChange={(e) => this.clickRsl(e, vntIndex)} />
          /* <Field component="input" type="checkbox" name={vntName} value={vntOnValue} onChange={(e) => this.clickRsl(e, vntIndex)} /> */
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
          <input
            type="text"
            name={`disease[${vntName}]`}
            maxLength="3"
            style={{ textAlign: 'right', width: `${size}px` }}
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
      // ドロップダウンリスト（続柄）
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

  scrollToAnchor = (anchorName) => {
    if (anchorName) {
      const anchorElement = document.getElementById(anchorName);
      // if (anchorElement) { anchorElement.scrollIntoView({ block: 'start', behavior: 'smooth' }); }
      if (anchorElement) {
        let PosY = anchorElement.offsetTop;
        PosY -= 192;
        // anchorElement.scrollIntoView({ block: 'start', behavior: 'smooth' });
        // window.scrollTo(0, Number(PosY));
        document.getElementById('ocrNyuryokuBody').scrollTo(0, Number(PosY));
      }
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

  // 保存
  save = (act) => {
    const { rsvno, onSave, chgRsl } = this.props;
    let count;
    let index;
    const buff = [];
    let i;
    let j;

    // ********
    // 前詰め
    // ********
    // 現病歴
    index = constants.OCRGRP_START1 + 2;
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
    index = constants.OCRGRP_START1 + 20;
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
    index = constants.OCRGRP_START1 + 38;
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
    index = constants.OCRGRP_START2 + 39;
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

  // OCR入力担当者クリア
  clrUser = (index) => {
    this.setChgRsl(index, '');
    if (document.getElementById('OpeNameBody')) {
      document.getElementById('OpeNameBody').innerHTML = '';
    }
  }

  // 献立のタグ生成
  editMenuList = (vntIndex) => {
    const marginSize = 2;
    const subHeight = 28;
    const subTitleWidth = 210;
    const subUnitWidth = 70;
    const titleWidth = 18;
    const titleHeight = subHeight * (31 - 1 + 1) + (31 - 1) * marginSize;
    const menuList = [];
    const kindWidth = 30;

    let bgcolor = '';
    let title = '';
    let i;

    // 画面上わかりにくいので表示
    if (vntIndex) {
      switch (vntIndex) {
        case constants.OCRGRP_START6: // 朝食
          bgcolor = '#ffe4b5';
          title = '朝';
          break;
        case constants.OCRGRP_START7: // 昼食
          bgcolor = '#f0e68c';
          title = '昼';
          break;
        case constants.OCRGRP_START8: // 夕食
          bgcolor = '#add8e6';
          title = '夕';
          break;
        default: break;
      }
    }

    const itemStyle = {
      float: 'left',
      marginBottom: `${marginSize}px`,
      marginRight: `${marginSize}px`,
      backgroundColor: `${bgcolor}`,
    };

    const errInfoDiv = [];
    for (i = 0; i < 31; i += 1) {
      errInfoDiv.push(<div style={{ ...itemStyle, backgroundColor: '', height: `${subHeight}px`, width: '20px' }}>{this.editErrInfo()}</div>);
    }
    menuList.push((
      <div>
        <div style={{ ...itemStyle, backgroundColor: '', height: `${subHeight}px`, width: '20px' }} />
        <div style={{ ...itemStyle, backgroundColor: '', height: `${subHeight}px`, width: `${titleWidth}px` }} />
        <div style={{ ...itemStyle, backgroundColor: '', height: `${subHeight}px`, width: `${titleWidth + subTitleWidth + subUnitWidth + marginSize * 2}px` }}>
          <span>主食</span>
        </div>
        <div style={{ ...itemStyle, backgroundColor: '', width: `${kindWidth}px`, height: '28px' }} />
        <div style={{ ...itemStyle, backgroundColor: '', height: `${subHeight}px`, width: `${titleWidth + subTitleWidth + subUnitWidth + marginSize * 2}px` }}>
          <span>主菜</span>
        </div>
        <div style={{ ...itemStyle, backgroundColor: '', width: `${kindWidth}px`, height: '28px' }} />
        <div style={{ ...itemStyle, backgroundColor: '', height: `${subHeight}px`, width: `${titleWidth + subTitleWidth + subUnitWidth + marginSize * 2}px` }}>
          <span>副菜</span>
        </div>
        <div style={{ clear: 'left' }} />

        <div style={{ ...itemStyle, backgroundColor: '', width: '20px', height: `${titleHeight}px` }}>
          {errInfoDiv}
        </div>
        <div style={{ ...itemStyle, width: `${titleWidth}px`, height: `${titleHeight}px`, lineHeight: `${titleHeight}px` }}>
          {title}
        </div>
        <div style={{ float: 'left' }}>
          {this.itemForMenuList('米', vntIndex, 1, 4, '#eeeeee', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('めん', vntIndex, 5, 13, '#eee8aa', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('パン', vntIndex, 14, 21, '#f5deb3', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('丼物', vntIndex, 22, 28, '#f0e68c', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('その他', vntIndex, 29, 31, '#ffc0cb', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
        </div>
        <div style={{ ...itemStyle, backgroundColor: '', width: `${kindWidth}px`, height: `${titleHeight}px` }} />
        <div style={{ float: 'left' }}>
          {this.itemForMenuList('魚', vntIndex, 32, 37, '#e0ffff', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('肉', vntIndex, 38, 46, '#ffc0cb', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('揚げ物', vntIndex, 47, 50, '#f0e68c', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('鍋', vntIndex, 51, 53, '#eee8aa', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('卵', vntIndex, 54, 58, '#fffacd', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('豆製品', vntIndex, 59, 62, '#e6e6fa', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
        </div>
        <div style={{ ...itemStyle, backgroundColor: '', width: `${kindWidth}px`, height: `${titleHeight}px` }} />
        <div style={{ float: 'left' }}>
          {this.itemForMenuList('野菜料理', vntIndex, 63, 75, '#98fb98', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('汁', vntIndex, 76, 78, '#ffdead', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
          {this.itemForMenuList('もう一品', vntIndex, 79, 82, '#fffacd', subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth)}
        </div>
        <div style={{ clear: 'left' }} />
      </div>
    ));
    return menuList;
  }

  itemForMenuList = (title, vntIndex, indexFrom, indexTo, bgcolor, subHeight, marginSize, titleWidth, subTitleWidth, subUnitWidth) => {
    const html = [];
    const items = [];

    const titleHeight = subHeight * (indexTo - indexFrom + 1) + (indexTo - indexFrom) * marginSize;
    let i;

    const itemStyle = {
      float: 'left',
      marginBottom: `${marginSize}px`,
      marginRight: `${marginSize}px`,
      backgroundColor: `${bgcolor}`,
    };
    for (i = indexFrom; i <= indexTo; i += 1) {
      items.push((
        <div key={`menuListItem${i}`}>
          <div style={{ ...itemStyle, width: `${subTitleWidth}px`, height: `${subHeight}px`, lineHeight: `${subHeight}px` }}>
            <span>{subTitles[i - 1]}</span>
          </div>
          <div style={{ ...itemStyle, width: `${subUnitWidth}px`, height: `${subHeight}px`, lineHeight: `${subHeight}px` }}>
            {this.editRsl(vntIndex + i, 'text', `Rsl[${vntIndex + i}]`, 2, '')}
            <span>{subUnits[i - 1]}</span>
          </div>
          <div style={{ clear: 'left' }} />
        </div>
      ));
    }

    html.push((
      <div>
        <div style={{ ...itemStyle, display: 'table', width: `${titleWidth}px`, height: `${titleHeight}px` }}>
          <div style={{ display: 'table-cell', verticalAlign: 'middle' }}>{title}</div>
        </div>
        <div style={{ float: 'left' }}>
          {items}
        </div>
        <div style={{ clear: 'left' }} />
      </div>
    ));

    return html;
  }

  render() {
    const { message, ocrNyuryoku, strOpeNameStc, consult } = this.props;
    errInfoNo = 0;

    if (!ocrNyuryoku || !ocrNyuryoku.ocrresult || ocrNyuryoku.ocrresult.length === 0) {
      return null;
    }

    return (
      <div>
        <MessageBanner messages={message} />

        <div style={{ minWidth: '1000px', marginTop: '20px' }}>
          {/* ****************************************************** */}
          {/*     現病歴既往歴                                       */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#98fb98', marginTop: '2px' }}>
            <span id="Anchor-DiseaseHistory" style={{ position: 'relative' }}>現病歴・既往歴問診票</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98fb98', marginLeft: '2px', marginTop: '2px' }}>
            <span>{`前回値 ${this.getLstCslDate(ocrNyuryoku)}`}</span>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>ブスコパン可否</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          {this.getResultArea0(constants.OCRGRP_START1 + 0)}
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea0(constants.OCRGRP_START1 + 0)}
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
            {this.editRsl(constants.OCRGRP_START1 + 1, 'radio', 'opt1_2', 0, '1')}<span>はい　</span>
            {this.editRsl(constants.OCRGRP_START1 + 1, 'radio', 'opt1_2', 0, '2')}<span>いいえ</span>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea1(constants.OCRGRP_START1 + 1)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>１．現在治療中又は定期的に受診中の病気について</span>
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
          <div style={{ float: 'left', height: '20px', width: '240px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>治療状況</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '144px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>メッセージ</span>
          </div>
          <div style={{ clear: 'left' }} />

          {/* 現病歴・既往歴問診票 ２ */}
          {this.getDisease1Area()}

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>２．既に治療や定期的な受診が終了した病気について</span>
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
          <div style={{ float: 'left', height: '20px', width: '240px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>治療状況</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '144px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>メッセージ</span>
          </div>
          <div style={{ clear: 'left' }} />

          {/* 現病歴・既往歴問診票 ２ */}
          {this.getDisease2Area()}

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>３．ご家族の方でかかった病気について</span>
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
          <div style={{ float: 'left', height: '20px', width: '240px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>続柄</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: '144px', backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }}>
            <span>メッセージ</span>
          </div>
          <div style={{ clear: 'left' }} />

          {/* 現病歴・既往歴問診票 ３ */}
          {this.getDisease3Area()}

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span id="Anchor-Stomach" style={{ position: 'relative' }}>４．胃検査を受ける方はお答え下さい</span>
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
              {this.editRsl(constants.OCRGRP_START1 + 56, 'radio', 'opt1_3', 0, '1')}<span>胃全摘手術　</span>
              {this.editRsl(constants.OCRGRP_START1 + 56, 'radio', 'opt1_3', 0, '2')}<span>胃部分切除　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea56(constants.OCRGRP_START1 + 56)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）妊娠していますか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 57, 'radio', 'opt1_4', 0, '1')}<span>はい</span>
              {this.editRsl(constants.OCRGRP_START1 + 57, 'radio', 'opt1_4', 0, '2')}<span>いいえ</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea57(constants.OCRGRP_START1 + 57)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>５．以前他院で指摘を受けたものがあれば、ご記入下さい。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１）胸部検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 58, 'checkbox', 'chk1_51_1', 0, '1')}<span>肺結核</span>
              {this.editRsl(constants.OCRGRP_START1 + 59, 'checkbox', 'chk1_51_2', 0, '2')}<span>無気肺</span>
              {this.editRsl(constants.OCRGRP_START1 + 60, 'checkbox', 'chk1_51_3', 0, '3')}<span>肺腺維症</span>
              {this.editRsl(constants.OCRGRP_START1 + 61, 'checkbox', 'chk1_51_4', 0, '4')}<span>胸膜瘢痕</span>
              {this.editRsl(constants.OCRGRP_START1 + 62, 'checkbox', 'chk1_51_5', 0, '5')}<span>陳旧性病変</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea58(constants.OCRGRP_START1 + 58)}
          </div>
          <div style={{ clear: 'left' }} />
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）上部消化管検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 63, 'checkbox', 'chk1_52_1', 0, '1')}<span>食道ポリープ　</span>
              {this.editRsl(constants.OCRGRP_START1 + 64, 'checkbox', 'chk1_52_2', 0, '2')}<span>胃新生物　</span>
              {this.editRsl(constants.OCRGRP_START1 + 65, 'checkbox', 'chk1_52_3', 0, '3')}<span>慢性胃炎　</span>
              {this.editRsl(constants.OCRGRP_START1 + 66, 'checkbox', 'chk1_52_4', 0, '4')}<span>胃ポリープ　</span>
              {this.editRsl(constants.OCRGRP_START1 + 67, 'checkbox', 'chk1_52_5', 0, '5')}<span>胃潰瘍瘢痕　</span>
              {this.editRsl(constants.OCRGRP_START1 + 68, 'checkbox', 'chk1_52_6', 0, '6')}<span>十二指腸　</span>
              {this.editRsl(constants.OCRGRP_START1 + 69, 'checkbox', 'chk1_52_7', 0, '7')}<span>その他　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea63(constants.OCRGRP_START1 + 63)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（３）上腹部超音波検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 70, 'checkbox', 'chk1_53_1', 0, '1')}<span>胆のうポリープ　</span>
              {this.editRsl(constants.OCRGRP_START1 + 71, 'checkbox', 'chk1_53_2', 0, '2')}<span>胆石　</span>
              {this.editRsl(constants.OCRGRP_START1 + 72, 'checkbox', 'chk1_53_3', 0, '3')}<span>肝血管腫　</span>
              {this.editRsl(constants.OCRGRP_START1 + 73, 'checkbox', 'chk1_53_4', 0, '4')}<span>肝嚢胞　</span>
              {this.editRsl(constants.OCRGRP_START1 + 74, 'checkbox', 'chk1_53_5', 0, '5')}<span>脂肪肝　</span>
              {this.editRsl(constants.OCRGRP_START1 + 75, 'checkbox', 'chk1_53_6', 0, '6')}<span>腎結石　</span>
              {this.editRsl(constants.OCRGRP_START1 + 76, 'checkbox', 'chk1_53_7', 0, '7')}<span>腎嚢胞　</span>
              {this.editRsl(constants.OCRGRP_START1 + 77, 'checkbox', 'chk1_53_8', 0, '8')}<span>その他　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea70(constants.OCRGRP_START1 + 70)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（４）心電図検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 78, 'checkbox', 'chk1_54_1', 0, '1')}<span>ＷＰＷ症候群　</span>
              {this.editRsl(constants.OCRGRP_START1 + 79, 'checkbox', 'chk1_54_2', 0, '2')}<span>完全右脚ブロック　</span>
              {this.editRsl(constants.OCRGRP_START1 + 80, 'checkbox', 'chk1_54_3', 0, '3')}<span>不完全右脚ブロック　</span>
              {this.editRsl(constants.OCRGRP_START1 + 81, 'checkbox', 'chk1_54_4', 0, '4')}<span>不整脈　</span>
              {this.editRsl(constants.OCRGRP_START1 + 82, 'checkbox', 'chk1_54_5', 0, '5')}<span>その他　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea78(constants.OCRGRP_START1 + 78)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（５）乳房検査</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START1 + 83, 'checkbox', 'chk1_55_1', 0, '1')}<span>乳腺症　</span>
              {this.editRsl(constants.OCRGRP_START1 + 84, 'checkbox', 'chk1_55_2', 0, '2')}<span>繊維線種　</span>
              {this.editRsl(constants.OCRGRP_START1 + 85, 'checkbox', 'chk1_55_3', 0, '3')}<span>その他　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea83(constants.OCRGRP_START1 + 83)}
          </div>
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
              {this.editRsl(constants.OCRGRP_START2 + 0, 'text', `Rsl[${constants.OCRGRP_START2 + 0}]`, 3, '')}ｋｇ
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea86(constants.OCRGRP_START2 + 0)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（２）この半年での体重の変動はどうですか。</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 1, 'radio', 'opt2_1', 0, '4')}<span>2ｋｇ以上増加した　</span>
              {this.editRsl(constants.OCRGRP_START2 + 1, 'radio', 'opt2_1', 0, '2')}<span>変動なし　</span>
              {this.editRsl(constants.OCRGRP_START2 + 1, 'radio', 'opt2_1', 0, '5')}<span>2ｋｇ以上減少した　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea87(constants.OCRGRP_START2 + 1)}
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
              {this.editRsl(constants.OCRGRP_START2 + 2, 'radio', 'opt2_2', 0, '1')}<span>習慣的に飲む　</span>
              <span>（週</span>{this.editRsl(constants.OCRGRP_START2 + 3, 'text', `Rsl[${constants.OCRGRP_START2 + 3}]`, 5, '')}<span>日）　</span>
              {this.editRsl(constants.OCRGRP_START2 + 2, 'radio', 'opt2_2', 0, '2')}<span>ときどき飲む　</span>
              {this.editRsl(constants.OCRGRP_START2 + 2, 'radio', 'opt2_2', 0, '3')}<span>飲まない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea88(constants.OCRGRP_START2 + 2)}
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
            {this.getLstResultArea90(constants.OCRGRP_START2 + 4)}
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
            {this.getLstResultArea90(constants.OCRGRP_START2 + 5)}
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
            {this.getLstResultArea90(constants.OCRGRP_START2 + 6)}
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
            {this.getLstResultArea90(constants.OCRGRP_START2 + 7)}
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
            {this.getLstResultArea90(constants.OCRGRP_START2 + 8)}
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
            {this.getLstResultArea90(constants.OCRGRP_START2 + 9)}
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
            {this.getLstResultArea90(constants.OCRGRP_START2 + 10)}
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
            {this.getLstResultArea90(constants.OCRGRP_START2 + 11)}
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
              {this.editRsl(constants.OCRGRP_START2 + 12, 'radio', 'opt2_3', 0, '1')}<span>吸っている　</span>
              {this.editRsl(constants.OCRGRP_START2 + 12, 'radio', 'opt2_3', 0, '2')}<span>吸わない　</span>
              {this.editRsl(constants.OCRGRP_START2 + 12, 'radio', 'opt2_3', 0, '3')}<span>過去に吸っていた　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea98(constants.OCRGRP_START2 + 12)}
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
            {this.getLstResultArea99(constants.OCRGRP_START2 + 13)}
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
            {this.getLstResultArea101(constants.OCRGRP_START2 + 15)}
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
              {this.editRsl(constants.OCRGRP_START2 + 16, 'radio', 'opt2_41', 0, '1')}<span>思う　</span>
              {this.editRsl(constants.OCRGRP_START2 + 16, 'radio', 'opt2_41', 0, '2')}<span>思わない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea102(constants.OCRGRP_START2 + 16)}
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
            {this.getLstResultArea103(constants.OCRGRP_START2 + 17)}
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
              {this.editRsl(constants.OCRGRP_START2 + 18, 'radio', 'opt2_43', 0, '1')}<span>よく体を動かす　</span>
              {this.editRsl(constants.OCRGRP_START2 + 18, 'radio', 'opt2_43', 0, '2')}<span>普通に動いている　</span>
              {this.editRsl(constants.OCRGRP_START2 + 18, 'radio', 'opt2_43', 0, '3')}<span>あまり活動的でない　</span>
              {this.editRsl(constants.OCRGRP_START2 + 18, 'radio', 'opt2_43', 0, '4')}<span>ほとんど体を動かさない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea104(constants.OCRGRP_START2 + 18)}
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
              {this.editRsl(constants.OCRGRP_START2 + 19, 'radio', 'opt2_44', 0, '1')}<span>ほとんど毎日　</span>
              {this.editRsl(constants.OCRGRP_START2 + 19, 'radio', 'opt2_44', 0, '2')}<span>週３～５日　</span>
              {this.editRsl(constants.OCRGRP_START2 + 19, 'radio', 'opt2_44', 0, '3')}<span>週１～２日　</span>
              {this.editRsl(constants.OCRGRP_START2 + 19, 'radio', 'opt2_44', 0, '4')}<span>ほとんどしない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea105(constants.OCRGRP_START2 + 19)}
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
              {this.editRsl(constants.OCRGRP_START2 + 20, 'radio', 'opt2_5', 0, '1')}<span>はい　</span>
              {this.editRsl(constants.OCRGRP_START2 + 20, 'radio', 'opt2_5', 0, '2')}<span>寝不足を感じる　　　　　</span>
              <span>睡眠時間（</span>{this.editRsl(constants.OCRGRP_START2 + 21, 'text', `Rsl[${constants.OCRGRP_START2 + 21}]`, 5, '')}<span>時間）　</span>
              <span>就寝時刻（</span>{this.editRsl(constants.OCRGRP_START2 + 22, 'text', `Rsl[${constants.OCRGRP_START2 + 22}]`, 5, '')}<span>時）　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea106(constants.OCRGRP_START2 + 20)}
          </div>
          <div style={{ clear: 'left' }} />

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
              {this.editRsl(constants.OCRGRP_START2 + 23, 'radio', 'opt2_6', 0, '1')}<span>毎食後に磨く　</span>
              {this.editRsl(constants.OCRGRP_START2 + 23, 'radio', 'opt2_6', 0, '2')}<span>１日１回は磨く　</span>
              {this.editRsl(constants.OCRGRP_START2 + 23, 'radio', 'opt2_6', 0, '3')}<span>１回も磨かない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea109(constants.OCRGRP_START2 + 23)}
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
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_71', 0, '1')}<span>肉体頭脳を要す労働　</span>
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_71', 0, '2')}<span>主に肉体的な労働　</span>
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_71', 0, '3')}<span>主に頭脳的な労働　</span>
              {this.editRsl(constants.OCRGRP_START2 + 24, 'radio', 'opt2_71', 0, '4')}<span>主に座り仕事　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea110(constants.OCRGRP_START2 + 24)}
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
              {this.editRsl(constants.OCRGRP_START2 + 25, 'radio', 'opt2_72', 0, '1')}<span>週3日以上　</span>
              {this.editRsl(constants.OCRGRP_START2 + 25, 'radio', 'opt2_72', 0, '2')}<span>週2日以上　</span>
              {this.editRsl(constants.OCRGRP_START2 + 25, 'radio', 'opt2_72', 0, '3')}<span>週1日　</span>
              {this.editRsl(constants.OCRGRP_START2 + 25, 'radio', 'opt2_72', 0, '4')}<span>月3日以下　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea111(constants.OCRGRP_START2 + 25)}
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
              {this.editRsl(constants.OCRGRP_START2 + 26, 'radio', 'opt2_73', 0, '1')}<span>徒歩　</span>
              {this.editRsl(constants.OCRGRP_START2 + 26, 'radio', 'opt2_73', 0, '2')}<span>自転車　</span>
              {this.editRsl(constants.OCRGRP_START2 + 26, 'radio', 'opt2_73', 0, '3')}<span>自動車（２輪を含む）　</span>
              {this.editRsl(constants.OCRGRP_START2 + 26, 'radio', 'opt2_73', 0, '4')}<span>電車・バス　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea112(constants.OCRGRP_START2 + 26)}
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
              {this.editRsl(constants.OCRGRP_START2 + 27, 'text', `Rsl[${constants.OCRGRP_START2 + 27}]`, 5, '')}<span>分（片道の通勤時間）　　</span>
              {this.editRsl(constants.OCRGRP_START2 + 28, 'text', `Rsl[${constants.OCRGRP_START2 + 28}]`, 5, '')}<span>分（片道の歩行時間）　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea113(constants.OCRGRP_START2 + 27)}
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
              {this.editRsl(constants.OCRGRP_START2 + 29, 'radio', 'opt2_75', 0, '1')}<span>あり　</span>
              {this.editRsl(constants.OCRGRP_START2 + 29, 'radio', 'opt2_75', 0, '2')}<span>なし　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea115(constants.OCRGRP_START2 + 29)}
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
              {this.editRsl(constants.OCRGRP_START2 + 30, 'checkbox', 'chk1_76_1', 0, '1')}<span>親　</span>
              {this.editRsl(constants.OCRGRP_START2 + 31, 'checkbox', 'chk1_76_2', 0, '2')}<span>配偶者　</span>
              {this.editRsl(constants.OCRGRP_START2 + 32, 'checkbox', 'chk1_76_3', 0, '3')}<span>子供　</span>
              {this.editRsl(constants.OCRGRP_START2 + 33, 'checkbox', 'chk1_76_4', 0, '4')}<span>独居　</span>
              {this.editRsl(constants.OCRGRP_START2 + 34, 'checkbox', 'chk1_76_5', 0, '5')}<span>その他</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea116(constants.OCRGRP_START2 + 30)}
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
              {this.editRsl(constants.OCRGRP_START2 + 35, 'radio', 'opt2_77', 0, '1')}<span>満足している　</span>
              {this.editRsl(constants.OCRGRP_START2 + 35, 'radio', 'opt2_77', 0, '2')}<span>やや満足している　</span>
              {this.editRsl(constants.OCRGRP_START2 + 35, 'radio', 'opt2_77', 0, '3')}<span>やや不満　</span>
              {this.editRsl(constants.OCRGRP_START2 + 35, 'radio', 'opt2_77', 0, '4')}<span>不満足　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea121(constants.OCRGRP_START2 + 35)}
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
              {this.editRsl(constants.OCRGRP_START2 + 36, 'radio', 'opt2_78', 0, '1')}<span>全く無かった　　</span>
              {this.editRsl(constants.OCRGRP_START2 + 36, 'radio', 'opt2_78', 0, '2')}<span>ややつらいことがあった　</span>
              {this.editRsl(constants.OCRGRP_START2 + 36, 'radio', 'opt2_78', 0, '3')}<span>つらいことがあった　</span>
              {this.editRsl(constants.OCRGRP_START2 + 36, 'radio', 'opt2_78', 0, '4')}<span>大変つらかった　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea122(constants.OCRGRP_START2 + 36)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（９）信仰心について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 37, 'radio', 'opt2_79', 0, '1')}<span>ある　</span>
              {this.editRsl(constants.OCRGRP_START2 + 37, 'radio', 'opt2_79', 0, '2')}<span>ややある　</span>
              {this.editRsl(constants.OCRGRP_START2 + 37, 'radio', 'opt2_79', 0, '3')}<span>ほとんどない　</span>
              {this.editRsl(constants.OCRGRP_START2 + 37, 'radio', 'opt2_79', 0, '4')}<span>まったくない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea123(constants.OCRGRP_START2 + 37)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <span>　　（１０）ボランティア活動について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '70px' }}>
              {this.editRsl(constants.OCRGRP_START2 + 38, 'radio', 'opt2_710', 0, '1')}<span>やっている　</span>
              {this.editRsl(constants.OCRGRP_START2 + 38, 'radio', 'opt2_710', 0, '2')}<span>やったことがある　</span>
              {this.editRsl(constants.OCRGRP_START2 + 38, 'radio', 'opt2_710', 0, '3')}<span>やりたいと思う　</span>
              {this.editRsl(constants.OCRGRP_START2 + 38, 'radio', 'opt2_710', 0, '4')}<span>やりたくない　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea124(constants.OCRGRP_START2 + 38)}
          </div>
          <div style={{ clear: 'left' }} />

          {/* 自覚症状表示 */}
          {this.editJikakushoujyou(constants.OCRGRP_START2 + 39)}

          {/* ****************************************************** */}
          {/*     生活習慣問診２                                      */}
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
              {this.editRsl(constants.OCRGRP_START3 + 0, 'checkbox', 'chk3_1', 0, '1')}<span style={{ fontWeight: 'bold' }}>本人希望により未回答</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea149(constants.OCRGRP_START3 + 0)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 1)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 2)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 3)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 4)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 5)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 6)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 7)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 8)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 9)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 10)}
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
            {this.getLstResultArea150(constants.OCRGRP_START3 + 11)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>２．ストレス・コーピングテスト</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '4px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '0px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 12, 'checkbox', 'chk3_2', 0, '1')}<span style={{ fontWeight: 'bold' }}>本人希望により未回答</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea161(constants.OCRGRP_START3 + 12)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '360px', marginTop: '2px' }} />
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              <span>全くしない</span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              <span>時にはある</span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              <span>しばしばある</span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              <span>常にある</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 1)積極的に解消しようと努力する</span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 13, 'radio', 'opt3_2_1', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 13, 'radio', 'opt3_2_1', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 13, 'radio', 'opt3_2_1', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 13, 'radio', 'opt3_2_1', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 13)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 2)自分への挑戦と受け止める </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 14, 'radio', 'opt3_2_2', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 14, 'radio', 'opt3_2_2', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 14, 'radio', 'opt3_2_2', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 14, 'radio', 'opt3_2_2', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 14)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 3)一休みするより頑張ろうとする </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 15, 'radio', 'opt3_2_3', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 15, 'radio', 'opt3_2_3', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 15, 'radio', 'opt3_2_3', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 15, 'radio', 'opt3_2_3', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 15)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 4)衝動買いや高価な買物をする </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 16, 'radio', 'opt3_2_4', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 16, 'radio', 'opt3_2_4', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 16, 'radio', 'opt3_2_4', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 16, 'radio', 'opt3_2_4', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 16)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 5)同僚や家族と出歩いたり飲み食いする </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 17, 'radio', 'opt3_2_5', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 17, 'radio', 'opt3_2_5', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 17, 'radio', 'opt3_2_5', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 17, 'radio', 'opt3_2_5', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 17)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 6)何か新しい事を始めようとする </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 18, 'radio', 'opt3_2_6', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 18, 'radio', 'opt3_2_6', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 18, 'radio', 'opt3_2_6', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 18, 'radio', 'opt3_2_6', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 18)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 7)今の状況から抜け出る事は無理だと思う </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 19, 'radio', 'opt3_2_7', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 19, 'radio', 'opt3_2_7', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 19, 'radio', 'opt3_2_7', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 19, 'radio', 'opt3_2_7', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 19)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 8)楽しかったことをボンヤリ考える </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 20, 'radio', 'opt3_2_8', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 20, 'radio', 'opt3_2_8', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 20, 'radio', 'opt3_2_8', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 20, 'radio', 'opt3_2_8', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 20)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span> 9)どうすれば良かったのかを思い悩む </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 21, 'radio', 'opt3_2_9', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 21, 'radio', 'opt3_2_9', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 21, 'radio', 'opt3_2_9', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 21, 'radio', 'opt3_2_9', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 21)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span>10)現在の状況について考えないようにする </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 22, 'radio', 'opt3_2_10', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 22, 'radio', 'opt3_2_10', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 22, 'radio', 'opt3_2_10', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 22, 'radio', 'opt3_2_10', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 22)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span>11)体の調子の悪い時には病院に行こうかと思う </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 23, 'radio', 'opt3_2_11', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 23, 'radio', 'opt3_2_11', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 23, 'radio', 'opt3_2_11', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 23, 'radio', 'opt3_2_11', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 23)}
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
            <div style={{ border: '1px solid #eeeeee', float: 'left', height: '28px', width: '360px', marginTop: '2px' }}>
              <span>12)以前よりタバコ・酒・食事の量が増える </span>
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 24, 'radio', 'opt3_2_12', 0, '1')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 24, 'radio', 'opt3_2_12', 0, '2')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 24, 'radio', 'opt3_2_12', 0, '3')}
            </div>
            <div style={{ border: '1px solid #eeeeee', textAlign: 'center', float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START3 + 24, 'radio', 'opt3_2_12', 0, '4')}
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
            {/* 前回値 */}
            {this.getLstResultArea162(constants.OCRGRP_START3 + 24)}
          </div>
          <div style={{ clear: 'left' }} />

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
                <span>1.子宮ガンの検診を受けたことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 0, 'radio', 'opt4_1', 0, '1')}<span>6ケ月以内　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 0, 'radio', 'opt4_1', 0, '2')}<span>6ケ月～1年以内　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 0, 'radio', 'opt4_1', 0, '3')}<span>1～2年以内　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 0, 'radio', 'opt4_1', 0, '4')}<span>3年前以上　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 0, 'radio', 'opt4_1', 0, '5')}<span>受けたことなし　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea174(constants.OCRGRP_START4 + 0)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>2.検診を受けた施設は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 1, 'radio', 'opt4_2', 0, '4')}<span>当院　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 1, 'radio', 'opt4_2', 0, '5')}<span>他集団検診　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 1, 'radio', 'opt4_2', 0, '6')}<span>他医院・他病院　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea175(constants.OCRGRP_START4 + 1)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>3.検診の結果は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 2, 'radio', 'opt4_3', 0, '1')}<span>異常なし　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 2, 'radio', 'opt4_3', 0, '2')}<span>異常あり（異型上皮）　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 2, 'radio', 'opt4_3', 0, '3')}<span>異常あり　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea176(constants.OCRGRP_START4 + 2)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>4.婦人科の病気をしたことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 3, 'checkbox', 'chk4_4_1', 0, '1')}<span>ない</span>
                  {this.editRsl(constants.OCRGRP_START4 + 4, 'checkbox', 'chk4_4_2', 0, '4')}<span>膣炎</span>
                  {this.editRsl(constants.OCRGRP_START4 + 5, 'checkbox', 'chk4_4_3', 0, '7')}<span>月経異常</span>
                  {this.editRsl(constants.OCRGRP_START4 + 6, 'checkbox', 'chk4_4_4', 0, '10')}<span>不妊</span>
                  {this.editRsl(constants.OCRGRP_START4 + 7, 'checkbox', 'chk4_4_5', 0, '2')}<span>子宮筋腫</span>
                  {this.editRsl(constants.OCRGRP_START4 + 8, 'checkbox', 'chk4_4_6', 0, '5')}<span>子宮内膜症</span>
                  {this.editRsl(constants.OCRGRP_START4 + 9, 'checkbox', 'chk4_4_7', 0, '8')}<span>子宮がん</span>
                  {this.editRsl(constants.OCRGRP_START4 + 10, 'checkbox', 'chk4_4_8', 0, '11')}<span>子宮頚管ポリープ</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea177(constants.OCRGRP_START4 + 3)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 11, 'checkbox', 'chk4_4_9', 0, '3')}<span>卵巣腫瘍（右）</span>
                  {this.editRsl(constants.OCRGRP_START4 + 12, 'checkbox', 'chk4_4_10', 0, '6')}<span>卵巣腫瘍（左）</span>
                  {this.editRsl(constants.OCRGRP_START4 + 13, 'checkbox', 'chk4_4_11', 0, '9')}<span>乳がん</span>
                  {this.editRsl(constants.OCRGRP_START4 + 14, 'checkbox', 'chk4_4_12', 0, '12')}<span>びらん</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea185(constants.OCRGRP_START4 + 11)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>5.今までにホルモン療法を受けたことは</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 15, 'radio', 'opt4_5', 0, '1')}<span>なし　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 15, 'radio', 'opt4_5', 0, '2')}<span>ある→　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 16, 'text', `Rsl[${constants.OCRGRP_START4 + 16}]`, 5, '')}<span>歳から</span>
                  {this.editRsl(constants.OCRGRP_START4 + 17, 'text', `Rsl[${constants.OCRGRP_START4 + 17}]`, 5, '')}<span>年間</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea189(constants.OCRGRP_START4 + 15)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>6.今までに病気で婦人科の手術をしたこと</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 18, 'radio', 'opt4_6', 0, '1')}<span>なし　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 18, 'radio', 'opt4_6', 0, '2')}<span>ある　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea192(constants.OCRGRP_START4 + 18)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '150px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 19, 'checkbox', 'chk4_6_1', 0, '3')}<span>子宮全摘術</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 20, 'text', `Rsl[${constants.OCRGRP_START4 + 20}]`, 3, '')}<span>歳</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea193(constants.OCRGRP_START4 + 19)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '150px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 21, 'checkbox', 'chk4_6_2', 0, '4')}<span>卵巣摘出術</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 22, 'text', `Rsl[${constants.OCRGRP_START4 + 22}]`, 3, '')}<span>歳</span>
                  {this.editRsl(constants.OCRGRP_START4 + 23, 'radio', 'opt4_6_2', 0, '7')}<span>右　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 23, 'radio', 'opt4_6_2', 0, '8')}<span>左　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 23, 'radio', 'opt4_6_2', 0, '9')}<span>両　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 23, 'radio', 'opt4_6_2', 0, '10')}<span>部分切除　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea195(constants.OCRGRP_START4 + 21)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', width: '150px', marginLeft: '35px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 24, 'checkbox', 'chk4_6_3', 0, '5')}<span>子宮筋腫核出術</span>
                </div>
                <div style={{ float: 'left' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 25, 'text', `Rsl[${constants.OCRGRP_START4 + 25}]`, 3, '')}<span>歳　</span>
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea198(constants.OCRGRP_START4 + 24)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>7.妊娠の回数</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 26, 'text', `Rsl[${constants.OCRGRP_START4 + 26}]`, 3, '')}<span>回</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea200(constants.OCRGRP_START4 + 26)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>8.出産の回数</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 27, 'text', `Rsl[${constants.OCRGRP_START4 + 27}]`, 3, '')}
                  <span>回　（そのうち帝王切開は</span>
                  {this.editRsl(constants.OCRGRP_START4 + 28, 'text', `Rsl[${constants.OCRGRP_START4 + 28}]`, 3, '')}
                  <span>回）</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea201(constants.OCRGRP_START4 + 27)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>9．１年以内に妊娠または出産</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 29, 'radio', 'opt4_9', 0, '1')}<span>はい　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 29, 'radio', 'opt4_9', 0, '2')}<span>いいえ　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea203(constants.OCRGRP_START4 + 29)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>10．閉経しましたか</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 30, 'radio', 'opt4_10', 0, '1')}<span>いいえ　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 30, 'radio', 'opt4_10', 0, '2')}<span>はい　→</span>
                  {this.editRsl(constants.OCRGRP_START4 + 31, 'text', `Rsl[${constants.OCRGRP_START4 + 31}]`, 3, '')}<span>歳</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea204(constants.OCRGRP_START4 + 30)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>11-1．最終月経</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 32, 'listdate', 'date11_1', 0, '')}
                  <span>～</span>
                  {this.editRsl(constants.OCRGRP_START4 + 35, 'listdate', 'date11_2', 0, '')}
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea206(constants.OCRGRP_START4 + 32)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>11-2．その前の月経</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ float: 'left', marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 37, 'listdate', 'date11_3', 0, '')}
                  <span>～</span>
                  {this.editRsl(constants.OCRGRP_START4 + 40, 'listdate', 'date11_4', 0, '')}
                </div>
                <div style={{ clear: 'left' }} />
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea206(constants.OCRGRP_START4 + 37)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>11-3．月経周期</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 42, 'text', `Rsl[${constants.OCRGRP_START4 + 42}]`, 2, '')}
                  <span>日　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 43, 'checkbox', 'chk4_11_3', 0, '1')}
                  <span>不規則</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea216(constants.OCRGRP_START4 + 42)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>11-4．月経期間</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 44, 'text', `Rsl[${constants.OCRGRP_START4 + 44}]`, 2, '')}
                  <span>日　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 45, 'checkbox', 'chk4_11_4', 0, '1')}
                  <span>不規則</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea216(constants.OCRGRP_START4 + 44)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>11-5．月経時の出血量</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 46, 'radio', 'opt4_11_5', 0, '1')}<span>少ない　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 46, 'radio', 'opt4_11_5', 0, '2')}<span>普通　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 46, 'radio', 'opt4_11_5', 0, '3')}<span>多い　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea220(constants.OCRGRP_START4 + 46)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>11-6．月経時、下腹部や腰部に痛みはありますか</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 47, 'radio', 'opt4_11_6', 0, '1')}<span>ない、又は軽い痛み　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 47, 'radio', 'opt4_11_6', 0, '2')}<span>強い痛みが時々ある　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 47, 'radio', 'opt4_11_6', 0, '3')}<span>毎回ひどい痛みがある　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea221(constants.OCRGRP_START4 + 47)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>12．今まで月経以外に出血したことはありますか</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 48, 'radio', 'opt4_12', 0, '1')}<span>ない　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 48, 'radio', 'opt4_12', 0, '2')}<span>１年以内にある　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 48, 'radio', 'opt4_12', 0, '3')}<span>１年以上前にある　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea222(constants.OCRGRP_START4 + 48)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>13．その他気になる症状はありますか</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 49, 'checkbox', 'chk4_13_1', 0, '1')}<span>ない</span>
                  {this.editRsl(constants.OCRGRP_START4 + 50, 'checkbox', 'chk4_13_2', 0, '2')}<span>おりものが気になる</span>
                  {this.editRsl(constants.OCRGRP_START4 + 51, 'checkbox', 'chk4_13_3', 0, '3')}<span>陰部がかゆい</span>
                  {this.editRsl(constants.OCRGRP_START4 + 52, 'checkbox', 'chk4_13_4', 0, '4')}<span>下腹部が痛い</span>
                  {this.editRsl(constants.OCRGRP_START4 + 53, 'checkbox', 'chk4_13_5', 0, '5')}<span>更年期症状がつらい</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea223(constants.OCRGRP_START4 + 49)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 54, 'checkbox', 'chk4_13_6', 0, '6')}<span>性交時に出血する</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea223(constants.OCRGRP_START4 + 54)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>14．現在、性生活はありますか</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 55, 'radio', 'opt4_14', 0, '1')}<span>ない　</span>
                  {this.editRsl(constants.OCRGRP_START4 + 55, 'radio', 'opt4_14', 0, '2')}<span>ある　</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea229(constants.OCRGRP_START4 + 55)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
              <div style={{ float: 'left', height: '20px', width: `${nowDivWidth}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
                <span>15．ご家族で婦人科系のガンにかかられた方は</span>
              </div>
              <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 56, 'checkbox', 'chk4_15_1', 0, '1')}<span>いない</span>
                  {this.editRsl(constants.OCRGRP_START4 + 57, 'checkbox', 'chk4_15_2', 0, '2')}<span>実母</span>
                  {this.editRsl(constants.OCRGRP_START4 + 58, 'checkbox', 'chk4_15_3', 0, '3')}<span>実姉妹</span>
                  {this.editRsl(constants.OCRGRP_START4 + 59, 'checkbox', 'chk4_13_4', 0, '4')}<span>その他</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea230(constants.OCRGRP_START4 + 56)}
              </div>
              <div style={{ clear: 'left' }} />

              <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
              <div style={{ float: 'left', height: '28px', width: `${nowDivWidth}px`, marginTop: '2px' }}>
                <div style={{ marginLeft: '24px' }}>
                  {this.editRsl(constants.OCRGRP_START4 + 60, 'checkbox', 'chk4_15_5', 0, '5')}<span>子宮体ガン</span>
                  {this.editRsl(constants.OCRGRP_START4 + 61, 'checkbox', 'chk4_15_6', 0, '6')}<span>子宮頚ガン</span>
                  {this.editRsl(constants.OCRGRP_START4 + 62, 'checkbox', 'chk4_15_7', 0, '7')}<span>卵巣ガン</span>
                  {this.editRsl(constants.OCRGRP_START4 + 63, 'checkbox', 'chk4_15_8', 0, '8')}<span>乳がん</span>
                  {this.editRsl(constants.OCRGRP_START4 + 64, 'checkbox', 'chk4_15_9', 0, '9')}<span>その他の婦人科系ガン</span>
                </div>
              </div>
              <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }}>
                {/* 前回値 */}
                {this.getLstResultArea230(constants.OCRGRP_START4 + 60)}
              </div>
              <div style={{ clear: 'left' }} />
            </div>}

          {(consult && consult.gender !== 2) &&
            <div>
              {Array(24).fill(0).map((v, i) => i + 1).forEach(() => { this.editErrInfo(); })}
            </div>}

          {/* ****************************************************** */}
          {/*     食習慣問診                                         */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, backgroundColor: '#98fb98', marginTop: '2px' }}>
            <span id="Anchor-Syokusyukan" style={{ position: 'relative' }}>食習慣問診票</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98fb98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '0px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 0, 'checkbox', 'chk5_1', 0, '1')}<span style={{ fontWeight: 'bold' }}>本人希望により未回答</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>１．摂取エネルギーについて</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '24px' }}>
              <span>カロリー制限を受けていますか</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '24px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 1, 'radio', 'opt5_1', 0, '1')}<span>はい　</span>
              {this.editRsl(constants.OCRGRP_START5 + 2, 'text', `Rsl[${constants.OCRGRP_START5 + 2}]`, 5, '')}<span>kcal　</span>
              {this.editRsl(constants.OCRGRP_START5 + 1, 'radio', 'opt5_1', 0, '2')}<span>いいえ　</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>２．食習慣について</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
              <span>1)食事の速度は速いほうですか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 3, 'radio', 'opt5_2_1', 0, '1')}<span>速いほうである</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 3, 'radio', 'opt5_2_1', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
              <span>2)満腹になるまで食べるほうですか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 4, 'radio', 'opt5_2_2', 0, '1')}<span>そうである</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 4, 'radio', 'opt5_2_2', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
              <span>3)食事の規則性は</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 5, 'radio', 'opt5_2_3', 0, '1')}<span>規則正しい</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 5, 'radio', 'opt5_2_3', 0, '2')}<span>それほどでもない</span>
            </div>
            <div style={{ float: 'left', height: '28px', marginTop: '2px', marginLeft: '2px' }}>
              <span>（１週間の平均欠食回数</span>
              {this.editRsl(constants.OCRGRP_START5 + 6, 'text', `Rsl[${constants.OCRGRP_START5 + 6}]`, 2, '')}
              <span>回）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
              <span>4)バランスを考えて食べていますか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 7, 'radio', 'opt5_2_4', 0, '1')}<span>考えている</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 7, 'radio', 'opt5_2_4', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
              <span>5)甘いものはよく食べますか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 8, 'radio', 'opt5_2_5', 0, '1')}<span>よく食べる</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 8, 'radio', 'opt5_2_5', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
              <span>6)脂肪分の多い食事は好んで食べますか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 9, 'radio', 'opt5_2_6', 0, '1')}<span>好んで食べる</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 9, 'radio', 'opt5_2_6', 0, '2')}<span>それほどでもない</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
              <span>8)間食をとることがありますか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 11, 'radio', 'opt5_2_8', 0, '1')}<span>食べない</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 11, 'radio', 'opt5_2_8', 0, '2')}<span>食べる</span>
            </div>
            <div style={{ float: 'left', height: '28px', marginTop: '2px', marginLeft: '2px' }}>
              <span>（１週間の平均間食回数</span>
              {this.editRsl(constants.OCRGRP_START5 + 12, 'text', `Rsl[${constants.OCRGRP_START5 + 12}]`, 2, '')}
              <span>回）</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '290px', marginTop: '2px' }}>
              <span>9)減塩醤油はお使いですか</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 13, 'radio', 'opt5_2_9', 0, '1')}<span>使っている</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '150px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 13, 'radio', 'opt5_2_9', 0, '2')}<span>使っていない</span>
            </div>
          </div>
          <div style={{ float: 'left', height: '28px', width: `${lstDivWidth}px`, marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '2px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>３．１日の嗜好品摂取量</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <div style={{ float: 'left', height: '28px', width: '230px', marginTop: '2px' }}>
              <span>　砂糖（小さじ）</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 15, 'text', `Rsl[${constants.OCRGRP_START5 + 15}]`, 2, '')}<span>杯</span>
            </div>

            <div style={{ float: 'left', height: '28px', width: '180px', marginTop: '2px' }}>
              <span>チョコレート</span>
            </div>
            <div style={{ float: 'left', height: '28px', width: '100px', marginTop: '2px', marginLeft: '2px' }}>
              {this.editRsl(constants.OCRGRP_START5 + 24, 'text', `Rsl[${constants.OCRGRP_START5 + 24}]`, 2, '')}<span>片</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, backgroundColor: '#eeeeee', marginTop: '2px' }}>
            <span>４．乳製品の１日摂取量</span>
          </div>
          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#eeeeee', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
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
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '5px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, backgroundColor: '#98FB98', marginTop: '2px' }}>
            <span id="Anchor-Morning">朝食について</span>
          </div>

          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98FB98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <span>　　（１）毎日食べていますか</span>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth3}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '55px' }}>
              {this.editRsl(constants.OCRGRP_START6 + 0, 'radio', 'opt6_1', 0, '1')}<span>食べる</span>
              {this.editRsl(constants.OCRGRP_START6 + 0, 'radio', 'opt6_1', 0, '2')}<span>時々食べる</span>
              {this.editRsl(constants.OCRGRP_START6 + 0, 'radio', 'opt6_1', 0, '3')}<span>食べない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', width: `${nowDivWidth3}px`, marginTop: '2px' }}>
            {this.editMenuList(constants.OCRGRP_START6)}
          </div>
          <div style={{ clear: 'left' }} />

          {/* ****************************************************** */}
          {/*     昼食                                               */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '5px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, backgroundColor: '#98FB98', marginTop: '2px' }}>
            <span id="Anchor-Lunch">昼食について</span>
          </div>

          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98FB98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <span>　　（１）毎日食べていますか</span>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth3}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '55px' }}>
              {this.editRsl(constants.OCRGRP_START7 + 0, 'radio', 'opt7_1', 0, '1')}<span>食べる</span>
              {this.editRsl(constants.OCRGRP_START7 + 0, 'radio', 'opt7_1', 0, '2')}<span>時々食べる</span>
              {this.editRsl(constants.OCRGRP_START7 + 0, 'radio', 'opt7_1', 0, '3')}<span>食べない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', width: `${nowDivWidth3}px`, marginTop: '2px' }}>
            {this.editMenuList(constants.OCRGRP_START7)}
          </div>
          <div style={{ clear: 'left' }} />

          {/* ****************************************************** */}
          {/*     夕食                                               */}
          {/* ****************************************************** */}
          <div style={{ float: 'left', height: '20px', width: '20px', marginTop: '5px' }} />
          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, backgroundColor: '#98FB98', marginTop: '2px' }}>
            <span id="Anchor-Dinner">夕食について</span>
          </div>

          <div style={{ float: 'left', height: '20px', width: `${lstDivWidth}px`, backgroundColor: '#98FB98', marginLeft: '2px', marginTop: '2px' }} />
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '20px', width: `${nowDivWidth2}px`, marginTop: '2px' }}>
            <span>　　（１）毎日食べていますか</span>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', height: '28px', width: '20px', marginTop: '2px' }}>{this.editErrInfo()}</div>
          <div style={{ float: 'left', height: '28px', width: `${nowDivWidth3}px`, marginTop: '2px' }}>
            <div style={{ marginLeft: '55px' }}>
              {this.editRsl(constants.OCRGRP_START8 + 0, 'radio', 'opt8_1', 0, '1')}<span>食べる</span>
              {this.editRsl(constants.OCRGRP_START8 + 0, 'radio', 'opt8_1', 0, '2')}<span>時々食べる</span>
              {this.editRsl(constants.OCRGRP_START8 + 0, 'radio', 'opt8_1', 0, '3')}<span>食べない</span>
            </div>
          </div>
          <div style={{ clear: 'left' }} />

          <div style={{ float: 'left', width: `${nowDivWidth3}px`, marginTop: '2px' }}>
            {this.editMenuList(constants.OCRGRP_START8)}
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
              <a role="presentation" style={{ cursor: 'pointer' }} onClick={() => this.clrUser(constants.OCRGRP_START9 + 0)}><span style={{ color: 'red' }}>X</span></a>
            </div>
            <div style={{ float: 'left', height: '20px', marginTop: '2px', marginRight: '3px' }}>
              <span id="OpeNameBody">{strOpeNameStc}</span>
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
ocrNyuryokuBody.propTypes = {
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

ocrNyuryokuBody.defaultProps = {
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
    message: state.app.dailywork.questionnaire.ocrNyuryokuBody.message,
    consult: state.app.dailywork.questionnaire.ocrNyuryokuBody.consult,
    perResultGrp: state.app.dailywork.questionnaire.ocrNyuryokuBody.perResultGrp,
    editOcrDate: state.app.dailywork.questionnaire.ocrNyuryokuBody.editOcrDate,
    ocrNyuryoku: state.app.dailywork.questionnaire.ocrNyuryokuBody.ocrNyuryoku,
    checkOcrNyuryoku: state.app.dailywork.questionnaire.ocrNyuryokuBody.checkOcrNyuryoku,
    chgRsl: selector(state, 'chgRsl'),
    strOpeNameStc: selector(state, 'strOpeNameStc'),
    act: selector(state, 'act'),
    lngErrCntE: selector(state, 'lngErrCntE'),
    lngErrCntW: selector(state, 'lngErrCntW'),
    errInfo: selector(state, 'errInfo'),
  };
};

const mapDispatchToProps = (dispatch) => ({
  // OCR入力結果確認（ボディ）情報取得
  onLoad: (conditions) => {
    // 指定対象受診者の検査結果を抽出する
    dispatch(getOcrNyuryokuBodyRequest(conditions));
  },
  // OCR入力結果保存
  onSave: (conditions) => {
    // 指定対象受診者の検査結果を抽出する
    dispatch(getOcrNyuryokuBodyRequest(conditions));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(ocrNyuryokuBody);
