import React from 'react';
import styled from 'styled-components';
import PropTypes from 'prop-types';
import { Field, reduxForm, getFormValues, blur } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import qs from 'qs';
import moment from 'moment';
import MessageBanner from '../../components/MessageBanner';
import DropDown from '../../components/control/dropdown/DropDown';
import CheckBox from '../../components/control/CheckBox';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import SectionBar from '../../components/SectionBar';
import RslUpdateHistoryMain from '../judgement/RslUpdateHistoryMain';
import Shokusyukan201210 from '../judgement/Shokusyukan201210';
import DiseaseHistory from '../judgement/DiseaseHistory';
import MonshinNyuryokuMain from '../judgement/MonshinNyuryokuMain';
import MenResult from '../judgement/MenResult';
import EntryRecogLevelList from '../judgement/EntryRecogLevelList';
import BodySignIcon from './BodySignIcon';
import CommentListFlame from '../../containers/preference/comment/CommentListFlameGuide';
import {
  getInterviewHeaderRequest,
  openUpdateLogGuide,
  openDiseaseHistoryGuide,
  openMonshinNyuryokuGuide,
  openMenResultGuide,
  openEntryRecogLevelGuide,
  openShokusyukan201210Guide,
} from '../../modules/judgement/interviewModule';
import { openCommentListFlameGuide } from '../../modules/preference/pubNoteModule';

const formName = 'InterviewHeader';
const WrapperSpace = styled.span`
  padding: 0 15px;
`;

class InterviewHeader extends React.Component {
  constructor(props) {
    super(props);
    const { reqwin } = props;
    if (reqwin && reqwin > 0) {
      this.handleDisplayTodayClick = this.handleDisplayTodayClick.bind(this);
      this.handleSubmit = this.handleSubmit.bind(this);
    }
  }

  componentDidMount() {
    const { onLoad } = this.props;
    onLoad(this.props);
  }

  // 総合判定ボタン押下時の処理
  handleDisplayTodayClick() {
    const { history, rsvno, setValue } = this.props;
    setValue('selecturl', '0');
    setValue('winmode', null);
    history.push(`/contents/judgement/interview/top/${rsvno}/totaljudview/0/0`);
  }

  // 別ウインドウで表示ボタン押下時の処理
  handleSubmit = (values) => {
    const { winmode, selecturl } = values;
    const { onOpenInterviewGuide, selecturlItems, history, rsvno } = this.props;
    const selecturlelement = selecturlItems.find((rec) => (rec.value.toString() === selecturl));
    if (selecturlelement !== undefined && selecturlelement !== null) {
      const { grpno, cscd, startdate, enddate, orgcd1, orgcd2, perid, ctrptcd } = selecturlelement;
      if (winmode === '1') {
        onOpenInterviewGuide({ data: { ...selecturlelement, ...values } });
      } else {
        const value = Number.parseInt(selecturl, 10);
        switch (true) {
          case value === 0:
            // 総合判定
            history.push(`/contents/judgement/interview/top/${rsvno}/totaljudview/${grpno}/0`);
            break;
          case value >= 1 && value <= 18:
            // 検査結果表示
            history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/menresult/${grpno}/0`);
            break;
          case value === 21:
            // 認識レベル～生活指導
            history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/entryrecoglevellist/${grpno}/0`);
            break;
          case value === 23:
            // 食習慣問診
            history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/shokusyukan201210/${grpno}/0`);
            break;
          case value === 25:
            // 変更履歴
            history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/rslupdatehistory/${grpno}/0`);
            break;
          case value === 26:
            // 病歴情報
            history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/diseasehistory/${grpno}/0`);
            break;
          case value === 27:
            // チャート情報
            history.replace({
              pathname: `/contents/judgement/interview/top/${rsvno}/${cscd}/commentlistflame/chart/${grpno}/0`,
              search: qs.stringify({ startdate, enddate, orgcd1, orgcd2, perid, ctrptcd, pubnotedivcd: '500', dispkbn: '1', dispmode: '2', cmtmode: '1,1,0,0' }),
            });
            break;
          case value === 28:
            // 注意事項情報
            history.replace({
              pathname: `/contents/judgement/interview/top/${rsvno}/${cscd}/commentlistflame/notice/${grpno}/0`,
              search: qs.stringify({ startdate, enddate, orgcd1, orgcd2, perid, ctrptcd, pubnotedivcd: '100', dispkbn: '1', dispmode: '2', cmtmode: '1,1,0,0' }),
            });
            break;
          case value === 29:
            // 問診
            history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/monshinnyuryoku/${grpno}/0`);
            break;
          default:
            break;
        }
      }
    }
  }

  // 描画処理
  render() {
    const { handleSubmit, message, reqwin, consult, optitems, perResultGrps, realage, specialcheck, selecturlItems, formValues, history } = this.props;
    const isShowDispBtn = (reqwin !== 0);
    const otherwin = () => {
      const { selecturl } = formValues;
      const params = {};
      if (selecturl) {
        const selecturlelement = selecturlItems.find((rec) => (rec.value.toString() === selecturl));
        const { grpno, cscd, rsvno } = selecturlelement;
        params.grpno = grpno;
        params.cscd = cscd;
        params.rsvno = rsvno;
        // チャート情報
        if (Number.parseInt(selecturl, 10) === 27 || Number.parseInt(selecturl, 10) === 28) {
          if (Number.parseInt(selecturl, 10) === 27) {
            params.pubnotedivcd = '500';
          }
          if (Number.parseInt(selecturl, 10) === 28) {
            params.pubnotedivcd = '100';
          }
          const { startdate, enddate, orgcd1, orgcd2, perid, ctrptcd } = selecturlelement;
          params.winmode = '1';
          params.dispkbn = '1';
          params.dispmode = '2';
          params.cmtmode = '1,1,0,0';
          params.startdate = startdate;
          params.enddate = enddate;
          params.orgcd1 = orgcd1;
          params.orgcd2 = orgcd2;
          params.perid = perid;
          params.ctrptcd = ctrptcd.toString();
        }
      }
      return params;
    };

    return (
      <div>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <SectionBar title="面接支援" />
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
                  <BodySignIcon name={rec.imagefilename} />
                ))}
              </FieldSet>
              {isShowDispBtn && (
                <FieldSet>
                  <Button onClick={this.handleDisplayTodayClick} value="総合判定" />
                  <Field name="selecturl" component={DropDown} items={selecturlItems} id="selectURL" selectedValue="0" />
                  <Label>を</Label>
                  <Field component={CheckBox} name="winmode" checkedValue="1" label="別ウインドウで" id="otherwin" />
                  <Button type="submit" value="表示" />
                </FieldSet>
              )}
            </FieldGroup>
          )}
        </form>
        {(isShowDispBtn && formValues.winmode === '1') && (
          <div>
            <RslUpdateHistoryMain match={{ params: { grpno: otherwin().grpno, winmode: '1', rsvno: otherwin().rsvno, cscd: otherwin().cscd } }} />
            <DiseaseHistory match={{ params: { grpno: otherwin().grpno, winmode: '1', rsvno: otherwin().rsvno, cscd: otherwin().cscd } }} />
            <MonshinNyuryokuMain match={{ params: { grpno: otherwin().grpno, winmode: '1', rsvno: otherwin().rsvno, cscd: otherwin().cscd } }} />
            <CommentListFlame match={{ params: otherwin() }} />
            <MenResult ismodal={1} history={history} params={{ grpno: '', winmode: '1', rsvno: otherwin().rsvno, cscd: otherwin().cscd }} />
            <EntryRecogLevelList match={{ params: { grpno: otherwin().grpno, winmode: '1', rsvno: otherwin().rsvno, cscd: otherwin().cscd } }} />
            <Shokusyukan201210 match={{ params: { grpno: otherwin().grpno, winmode: '1', rsvno: otherwin().rsvno, cscd: otherwin().cscd } }} />
          </div>
        )}
      </div>
    );
  }
}

// propTypesの定義
InterviewHeader.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  consult: PropTypes.shape(),
  optitems: PropTypes.arrayOf(PropTypes.shape()),
  perResultGrps: PropTypes.arrayOf(PropTypes.shape()),
  realage: PropTypes.number,
  specialcheck: PropTypes.number,
  reqwin: PropTypes.number,
  onOpenInterviewGuide: PropTypes.func,
  selecturlItems: PropTypes.arrayOf(PropTypes.shape()),
  formValues: PropTypes.shape(),
  setValue: PropTypes.func.isRequired,
  rsvno: PropTypes.string.isRequired,
};

// defaultPropsの定義
InterviewHeader.defaultProps = {
  formValues: {},
  realage: null,
  specialcheck: undefined,
  reqwin: undefined,
  consult: {},
  optitems: [],
  perResultGrps: [],
  selecturlItems: [],
  onOpenInterviewGuide: null,
};

const InterviewHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  destroyOnUnmount: false,
})(InterviewHeader);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    message: state.app.judgement.interview.interviewHeader.message,
    consult: state.app.judgement.interview.interviewHeader.consult,
    optitems: state.app.judgement.interview.interviewHeader.optitems,
    perResultGrps: state.app.judgement.interview.interviewHeader.perResultGrps,
    realage: state.app.judgement.interview.interviewHeader.realage,
    specialcheck: state.app.judgement.interview.interviewHeader.specialcheck,
    selecturlItems: state.app.judgement.interview.interviewHeader.selecturlItems,
  };
};

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
  onOpenInterviewGuide: ({ data }) => {
    const { selecturl, grpno } = data;
    const value = Number.parseInt(selecturl, 10);
    switch (true) {
      case value >= 1 && value <= 18:
        // 検査結果表示
        dispatch(openMenResultGuide(grpno));
        break;
      case value === 21:
        // 生活指導コメント
        dispatch(openEntryRecogLevelGuide());
        break;
      case value === 23:
        // 食習慣問診
        dispatch(openShokusyukan201210Guide());
        break;
      case value === 25:
        // 変更履歴
        dispatch(openUpdateLogGuide());
        break;
      case value === 26:
        // 病歴情報
        dispatch(openDiseaseHistoryGuide());
        break;
      case value === 27:
      case value === 28:
        // チャート情報
        // 注意事項
        dispatch(openCommentListFlameGuide());
        break;
      case value === 29:
        // 問診
        dispatch(openMonshinNyuryokuGuide());
        break;
      default:
        break;
    }
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(InterviewHeaderForm));
