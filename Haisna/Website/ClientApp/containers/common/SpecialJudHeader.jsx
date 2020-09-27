import React from 'react';
import styled from 'styled-components';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import { getInterviewHeaderRequest } from '../../modules/judgement/interviewModule';
import SectionBar from '../../components/SectionBar';
import BodySignIcon from './BodySignIcon';

const WrapperSpace = styled.span`
  padding: 0 15px;
`;

class SpecialJudHeader extends React.Component {
  componentDidMount() {
    const { rsvno, onLoad } = this.props;
    onLoad({ rsvno });
  }

  // 描画処理
  render() {
    const { message, consult, optitems, perResultGrps, realage, specialcheck } = this.props;
    return (
      <div>
        <div>
          <SectionBar title="面接支援" />
        </div>
        <MessageBanner messages={message} />
        {message && message.length === 0 && (
          <FieldGroup itemWidth={75}>
            <FieldSet>
              <FieldItem>受診日</FieldItem>
              <Label><span style={{ color: '#ff6600' }}><strong>{(consult.csldate) ? (moment(consult.csldate).format('YYYY/MM/DD')) : ''}</strong></span></Label>
              <WrapperSpace />
              <FieldItem>コース</FieldItem>
              <Label><span style={{ color: '#ff6600' }}><strong>{consult.csname}</strong></span></Label>
              <WrapperSpace />
              <FieldItem>当日ＩＤ</FieldItem>
              <Label><span style={{ color: '#ff6600' }}><strong>{(consult.dayid) ? ((consult.dayid).toString().padStart(4, '0')) : ''}</strong></span></Label>
              <WrapperSpace />
              <FieldItem>団体</FieldItem>
              <Label>{consult.orgname}</Label>
              <WrapperSpace />
              {specialcheck !== undefined && specialcheck > 0 && <BodySignIcon name="physical10" />}
              <WrapperSpace />
              {optitems && optitems.map((rec, index) => (
                <Label key={index.toString()}>{rec.optname}</Label>
              ))}
            </FieldSet>
            <FieldSet>
              <Label>{consult.perid}</Label>
              <Label><b>{consult.lastname}　{consult.firstname}</b></Label>
              <Label>（{consult.lastkname}　{consult.firstkname}）</Label>
              <Label>{(consult.csldate) ? (moment(consult.birth).format('YYYY年MM日DD')) : ''}生</Label>
              <Label>
                {(consult.birth && consult.birth != null) ? (Number.parseInt(realage, 10)) : ''}歳({Number.parseInt(consult.age, 10)}歳)
              </Label>
              <Label>
                {(consult.gender && consult.gender === 1) ? '男性' : '女性'}
              </Label>
              <WrapperSpace />
              <FieldItem>受診回数</FieldItem>
              <Label><span style={{ color: '#ff6600' }}><strong>{consult.cslcount}</strong></span></Label>
              <WrapperSpace />
              <FieldItem>身体情報</FieldItem>
              {perResultGrps && perResultGrps.map((rec) => (
                <WrapperSpace key={rec.itemcd}>
                  <BodySignIcon name={rec.imagefilename} />
                </WrapperSpace>
              ))}
            </FieldSet>
          </FieldGroup>
        )}
      </div>
    );
  }
}

// propTypesの定義
SpecialJudHeader.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  consult: PropTypes.shape(),
  optitems: PropTypes.arrayOf(PropTypes.shape()),
  perResultGrps: PropTypes.arrayOf(PropTypes.shape()),
  realage: PropTypes.number,
  specialcheck: PropTypes.number,
  rsvno: PropTypes.string.isRequired,
};
// defaultPropsの定義
SpecialJudHeader.defaultProps = {
  realage: null,
  specialcheck: null,
  consult: {},
  optitems: [],
  perResultGrps: [],
};
const mapStateToProps = (state) => ({
  message: state.app.judgement.interview.interviewHeader.message,
  consult: state.app.judgement.interview.interviewHeader.consult,
  optitems: state.app.judgement.interview.interviewHeader.optitems,
  perResultGrps: state.app.judgement.interview.interviewHeader.perResultGrps,
  realage: state.app.judgement.interview.interviewHeader.realage,
  specialcheck: state.app.judgement.interview.interviewHeader.specialcheck,
  selecturlItems: state.app.judgement.interview.interviewHeader.selecturlItems,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    const { rsvno } = params;
    if (rsvno === null || rsvno === undefined) {
      return;
    }
    // 面接支援ヘッダ情報
    dispatch(getInterviewHeaderRequest({ rsvno }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(SpecialJudHeader);

