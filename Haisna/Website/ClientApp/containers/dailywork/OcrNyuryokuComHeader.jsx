import React from 'react';
import moment from 'moment';
import styled from 'styled-components';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import Label from '../../components/control/Label';
import { FieldSet, FieldItem } from '../../components/Field';
import MessageBanner from '../../components/MessageBanner';

import { loadOcrNyuryokuComHeaderInfo } from '../../modules/dailywork/questionnaire1Module';

const WrapperSpace = styled.span`
  padding: 0 10px;
`;

class OcrNyuryokuComHeader extends React.Component {
  // 画面を初期化
  componentDidMount() {
    const { onLoad, rsvno } = this.props;
    const params = { rsvno };
    // onLoadアクションの引数として渡す
    onLoad(params);
  }

  render() {
    // 引数値の取得
    const { consultdata, optdata, spcheckdata, perrsldata, editorcdate, realagetxt, message, titlename } = this.props;
    return (
      <div style={{ width: '100%' }}>
        <MessageBanner messages={message} />
        <FieldSet>
          <div style={{ width: '82%', border: '1px solid' }}>
            <span style={{ color: '#8600FF', fontWeight: 'bold' }} >■</span>
            <Label><span style={{ color: '#000000' }}><b>{titlename}</b></span></Label>
          </div>
          <div style={{ width: '18%', border: '1px solid' }}>
            {(!editorcdate.editocrdate) &&
              <Label><span style={{ color: '#FF0000' }}>OCR結果未登録です。</span></Label>
            }
            {(editorcdate.editocrdate) &&
              <Label><span style={{ color: '#FF0000' }}>{`OCR結果登録済み:(${editorcdate ? moment(editorcdate.editocrdate).format('MM/DD/YYYY h:mm:ss A') : ''})`}</span></Label>
            }
          </div>
        </FieldSet>
        <FieldSet>
          <FieldItem>受診日</FieldItem>
          <Label><span style={{ color: '#ff6600' }}><strong>{(consultdata.csldate) ? (moment(consultdata.csldate).format('YYYY/MM/DD')) : ''}</strong></span></Label>
          <WrapperSpace />
          <FieldItem>コース</FieldItem>
          <Label><span style={{ color: '#ff6600' }}><strong>{consultdata.csname}</strong></span></Label>
          <WrapperSpace />
          <FieldItem>当日ＩＤ</FieldItem>
          <Label><span style={{ color: '#ff6600' }}><strong>{(consultdata.dayid) ? ((consultdata.dayid).toString().padStart(4, '0')) : ''}</strong></span></Label>
          <WrapperSpace />
          <FieldItem>団体</FieldItem>
          <Label>{consultdata.orgname}</Label>
          <WrapperSpace />
          <div>
            {spcheckdata && spcheckdata > 0 &&
              <Label>特定保健指導対象</Label>
            }
            {optdata && optdata.map((rec) => (
              <WrapperSpace key={rec.seq}>
                <Label>{rec.optname}</Label>
                {/* <img src={require(`../../images/${rec.imagefilename}`)} title={rec.itemname} alt={rec.itemname} /> */}
              </WrapperSpace>
            ))}
          </div>
        </FieldSet>
        <FieldSet>
          <Label>{consultdata.perid}</Label>
          <Label><b>{consultdata.lastname}{consultdata.firstname}</b></Label>
          <Label>（{consultdata.lastkname}　{consultdata.firstkname}）</Label>
          <Label>{(consultdata.csldate) ? (moment(consultdata.birth).format('YYYY年MM日DD')) : ''}生</Label>
          <Label>
            {realagetxt === undefined ? '' : realagetxt}歳({consultdata && consultdata.age ? Number.parseInt(consultdata.age, 10) : ''}歳)
          </Label>
          <Label>
            {(consultdata.gender && consultdata.gender === 1) ? '男性' : '女性'}
          </Label>
          <WrapperSpace />
          <FieldItem>受診回数</FieldItem>
          <Label><span style={{ color: '#ff6600' }}><strong>{consultdata.cslcount}</strong></span></Label>
          <WrapperSpace />
          <FieldItem>身体情報</FieldItem>
          {perrsldata[0] && perrsldata[0].perResultGrp.map((rec) => (
            <WrapperSpace key={rec.itemcd}>
              <Label>{rec.itemname}</Label>
              {/* <img src={require(`../../images/${rec.imagefilename}`)} title={rec.itemname} alt={rec.itemname} /> */}
            </WrapperSpace>
          ))}
        </FieldSet>
      </div>
    );
  }
}

// propTypesの定義
OcrNyuryokuComHeader.propTypes = {
  onLoad: PropTypes.func.isRequired,
  realagetxt: PropTypes.number,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  rsvno: PropTypes.string.isRequired,
  optdata: PropTypes.arrayOf(PropTypes.shape()),
  spcheckdata: PropTypes.number,
  perrsldata: PropTypes.arrayOf(PropTypes.shape()),
  editorcdate: PropTypes.shape(),
  consultdata: PropTypes.shape(),
  titlename: PropTypes.string.isRequired,
};

OcrNyuryokuComHeader.defaultProps = {
  optdata: [],
  spcheckdata: 0,
  perrsldata: [],
  editorcdate: {},
  consultdata: {},
  realagetxt: 0,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  message: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.message,
  realagetxt: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.realagetxt,
  optdata: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.optdata,
  spcheckdata: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.spcheckdata,
  perrsldata: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.perrsldata,
  editorcdate: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.editorcdate,
  gfchecklist: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.gfchecklist,
  consultdata: state.app.dailywork.questionnaire1.ocrNyuryokuComHeader.consultdata,
});

const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    dispatch(loadOcrNyuryokuComHeaderInfo(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OcrNyuryokuComHeader);
