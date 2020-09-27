import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { FieldSet } from '../../components/Field';
import Button from '../../components/control/Button';
import OcrNyuryokuComHeade from './OcrNyuryokuComHeader';
import MessageBanner from '../../components/MessageBanner';

import { setMonshinChangeOption, setNaishikyou } from '../../modules/dailywork/questionnaire1Module';
import { openChangeOptionGuide } from '../../modules/reserve/consultModule';
import { openNaishikyouCheckGuide } from '../../modules/result/resultModule';

class OcrNyuryokuSpHeader extends React.Component {
  constructor(props) {
    super(props);
    this.handleOpenMonshinChangeOption = this.handleOpenMonshinChangeOption.bind(this);
    this.handleOpenNaishikyou = this.handleOpenNaishikyou.bind(this);
    this.handleJumpAnchor = this.handleJumpAnchor.bind(this);
    this.handleCopyOcrNyuryoku = this.handleCopyOcrNyuryoku.bind(this);
    this.handleSaveOcrNyuryoku = this.handleSaveOcrNyuryoku.bind(this);
  }

  // 受診検査項目変更画面呼び出し
  handleOpenMonshinChangeOption() {
    const { openMonshin } = this.props;
    const { rsvno } = this.props;
    const { parms } = rsvno;
    openMonshin(parms);
  }

  // 内視鏡チェックリスト入力画面呼び出し
  handleOpenNaishikyou() {
    const { openNaishi } = this.props;
    const { rsvno } = this.props;
    const { parms } = rsvno;
    openNaishi(parms);
  }

  // 前回値を複写押下時の処理
  handleCopyOcrNyuryoku = () => {
    const { body } = this.props;
    body.copyOcrNyuryoku();
  }

  // OCR入力内容を保存押下時の処理
  handleSaveOcrNyuryoku = () => {
    const { body } = this.props;
    body.save('check');
  }

  // メニューを選択
  handleJumpAnchor = (anchorName) => {
    let PosY = 0;
    if (anchorName) {
      const anchorElement = document.getElementById(anchorName);
      if (anchorElement) {
        PosY = anchorElement.offsetTop;
        PosY -= 500;
        document.getElementById('OcrNyuryokuSpBody2').scrollTo(0, Number(PosY));
      }
    }
  }
  render() {
    // 引数値の取得
    const { rsvno, consultdata, message } = this.props;

    return (
      <form>
        <MessageBanner messages={message} />
        <div style={{ width: 1850 }}>
          <FieldSet>
            <OcrNyuryokuComHeade rsvno={rsvno} titlename="OCR入力結果確認（新）" />
          </FieldSet>
          <FieldSet>
            {consultdata && consultdata.gender === '2' && (
              <div style={{ width: '40%' }}>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-DiseaseHistory'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>現病歴既往歴  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-LifeHabit1'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>生活習慣問診１  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-LifeHabit2'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>生活習慣問診２  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Fujinka'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>婦人科問診  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Syokusyukan'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>食習慣問診  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Morning'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>朝食  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Lunch'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>昼食  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Dinner'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>夕食 </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Special'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>特定健診 </b></span>
                </a>
              </div>
            )}
            {consultdata && consultdata.gender !== '2' && (
              <div style={{ width: '40%' }}>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-DiseaseHistory'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>現病歴既往歴  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-LifeHabit1'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>生活習慣問診１  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-LifeHabit2'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>生活習慣問診２  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Syokusyukan'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>食習慣問診  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Morning'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>朝食  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Lunch'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>昼食  | </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Dinner'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>夕食  |  </b></span>
                </a>
                <a style={{ cursor: 'pointer' }} role="presentation" onClick={() => (this.handleJumpAnchor('Anchor-Special'))}>
                  <span style={{ color: '#000000', fontSize: '16px', textShadow: '3px 5px 10px' }}><b>特定健診 </b></span>
                </a>
              </div>
            )}
            <div style={{ width: 1130, hight: 30, float: 'right' }}>
              <div style={{ width: 100, hight: 30, float: 'right' }}>
                <Button onClick={() => this.handleSaveOcrNyuryoku()} value="保存" />
              </div>
              <div style={{ width: 170, hight: 30, float: 'right' }}>
                <Button onClick={this.handleOpenNaishikyou} value="内視鏡チェックリスト" />
              </div>
              <div style={{ width: 110, hight: 30, float: 'right' }}>
                <Button onClick={this.handleOpenMonshinChangeOption} value="検査項目変更" />
              </div>
              <div style={{ width: 105, hight: 30, float: 'right' }}>
                <Button onClick={() => this.handleCopyOcrNyuryoku()} value="前回複写" />
              </div>
            </div>
          </FieldSet>
        </div>
      </form>
    );
  }
}

// propTypesの定義
OcrNyuryokuSpHeader.propTypes = {
  body: PropTypes.shape(),
  rsvno: PropTypes.string.isRequired,
  openMonshin: PropTypes.func.isRequired,
  openNaishi: PropTypes.func.isRequired,
  consultdata: PropTypes.shape(),
  message: PropTypes.arrayOf(PropTypes.string),
};

OcrNyuryokuSpHeader.defaultProps = {
  consultdata: {},
  message: [],
  body: {},
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  consultdata: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.consultdata,
});

const mapDispatchToProps = (dispatch) => ({
  // 受診検査項目変更画面呼び出し
  openMonshin: (parms) => {
    dispatch(openChangeOptionGuide(parms));
    dispatch(setMonshinChangeOption());
  },
  // 内視鏡チェックリスト入力画面呼び出し
  openNaishi: () => {
    dispatch(openNaishikyouCheckGuide());
    dispatch(setNaishikyou());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OcrNyuryokuSpHeader);
