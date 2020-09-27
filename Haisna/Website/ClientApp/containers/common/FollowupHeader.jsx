import React from 'react';
import styled from 'styled-components';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import BodySignIcon from './BodySignIcon';
import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import { getFollowUpHeaderRequest } from '../../modules/judgement/interviewModule';

const WrapperSpace = styled.span`
  padding: 0 15px;
`;

class FollowupHeader extends React.Component {
  componentDidMount() {
    const { onLoad } = this.props;
    onLoad(this.props);
  }

  // 描画処理
  render() {
    const { message, consult, optitems, perResultGrps, realage, specialcheck } = this.props;
    return (
      <div>
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
              <Label><strong>{consult.orgname}</strong></Label>
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
                <BodySignIcon name={rec.imagefilename} />
              ))}
            </FieldSet>
          </FieldGroup>
        )}
      </div>
    );
  }
}

// propTypesの定義
FollowupHeader.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  consult: PropTypes.shape(),
  optitems: PropTypes.arrayOf(PropTypes.shape()),
  perResultGrps: PropTypes.arrayOf(PropTypes.shape()),
  realage: PropTypes.number,
  specialcheck: PropTypes.number,
};

// defaultPropsの定義
FollowupHeader.defaultProps = {
  realage: null,
  specialcheck: null,
  consult: {},
  optitems: [],
  perResultGrps: [],
};

const mapStateToProps = (state) => ({
  message: state.app.judgement.interview.followUpHeader.message,
  consult: state.app.judgement.interview.followUpHeader.consult,
  optitems: state.app.judgement.interview.followUpHeader.optitems,
  perResultGrps: state.app.judgement.interview.followUpHeader.perResultGrps,
  realage: state.app.judgement.interview.followUpHeader.realage,
  specialcheck: state.app.judgement.interview.followUpHeader.specialcheck,

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
    dispatch(getFollowUpHeaderRequest({ rsvno }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowupHeader);

