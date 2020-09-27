import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import moment from 'moment';
import styled from 'styled-components';
import Button from '../../../components/control/Button';
import { searchCommentListRequest } from '../../../modules/preference/pubNoteModule';
import LabelOrgName from '../../../components/control/label/LabelOrgName';
import Label from '../../../components/control/Label';
import MessageBanner from '../../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import CheckBox from '../../../components/control/CheckBox';
import DropDown from '../../../components/control/dropdown/DropDown';
import DropDownPubNoteDivCd from '../../../components/control/dropdown/DropDownPubNoteDivCd';
import CommentDetailGuide from '../../../containers/preference//comment/CommentDetailGuide';

const Wrapper = styled.span`
   color: #ff6600;
`;

// 送信方法選択肢
const sendmethodItems = [{ value: 1, name: '医療情報のみ表示' }, { value: 2, name: '事務情報のみ表示' }];

const forName = 'CommentListHeader';


const ConsultDisplay = ({ params, consult }) => {
  let dayid = null;
  const res = [];
  if ((params.dispmode) !== '2') {
    if (params.rsvno !== null && params.rsvno !== undefined) {
      if (consult && consult.dayid !== undefined && consult.dayid !== null) {
        if (consult.dayid.toString().length === 1) {
          dayid = `000${consult.dayid}`;
        } else if (consult.dayid.toString().length === 2) {
          dayid = `00${consult.dayid}`;
        } else if (consult.dayid.toString().length === 3) {
          dayid = `0${consult.dayid}`;
        } else if (consult.dayid.toString().length === 4) {
          dayid = `${consult.dayid}`;
        }
      }
      // 受診情報の表示
      res.push(<FieldItem key={1}>受診日</FieldItem>);
      res.push(<Wrapper key={1}>{moment(consult ? consult.csldate : null).format('YYYY/MM/DD')}</Wrapper>);
      res.push(<FieldItem key={2}>　コース</FieldItem>);
      res.push(<Wrapper key={2}>{consult && consult.csname}</Wrapper>);
      res.push(<FieldItem key={3}>　当日ＩＤ</FieldItem>);
      res.push(<Wrapper key={3}>{dayid}</Wrapper>);
      res.push(<FieldItem key={4}>　団体</FieldItem>);
      if (params.orgcd1 !== null && params.orgcd2 !== null) {
        res.push(<LabelOrgName orgcd1={params.orgcd1} orgcd2={params.orgcd2} key={4} />);
      }
    } else if (params.orgcd1 !== null && params.orgcd2 !== null && params.orgcd1 !== undefined && params.orgcd2 !== undefined) {
      res.push(<FieldSet key={4}><FieldItem>団体</FieldItem><LabelOrgName orgcd1={params.orgcd1} orgcd2={params.orgcd2} /></FieldSet>);
    }
  }
  return res;
};

class CommentListHeader extends React.Component {
  constructor(props) {
    super(props);
    this.handleOnSearchClick = this.handleOnSearchClick.bind(this);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { detailRefresh, onSubmit, formValues, params } = this.props;
    if (nextProps.detailRefresh !== detailRefresh && nextProps.detailRefresh) {
      onSubmit(params, formValues);
    }
  }

  // 検索
  handleOnSearchClick() {
    const { params, onSubmit, formValues } = this.props;
    onSubmit(params, formValues);
  }

  // 描画処理
  render() {
    const { handleSubmit, consult, onOpenCommentDetailGuide, params, message } = this.props;
    const { rsvno, perid, orgcd1, orgcd2, ctrptcd } = params;
    return (
      <div>
        <form>
          <FieldGroup itemWidth={100}>
            <FieldSet key={1}>
              <MessageBanner messages={message} />
              <ConsultDisplay consult={consult} params={params} />
            </FieldSet>
            {params.dispmode !== '2' && ((params.rsvno !== null && params.rsvno !== undefined) && (params.perid !== null && params.perid !== undefined)) &&
              <FieldSet>
                {params.perid}&nbsp;&nbsp;
                <strong>{consult && consult.lastname}&nbsp;&nbsp;{consult && consult.firstname}</strong>&nbsp;&nbsp;
                ({consult && consult.lastkname}&nbsp;&nbsp;{consult && consult.firstkname})&nbsp;&nbsp;
                {consult && consult.birthyearshorteraname}{consult && consult.birtherayear} {moment(consult && consult.birth).format('MM.DD')}生&nbsp;&nbsp;
                {Math.floor(Number(consult && consult.age))}歳&nbsp;&nbsp;
                {(consult && consult.gender === 1) ? '男性' : '女性'}
              </FieldSet>
            }
            <FieldSet key={2}>
              <FieldItem>表示期間</FieldItem>
              <Field name="startdate" component={DatePicker} /><Label>～ </Label><Field name="enddate" component={DatePicker} />
              <Field component={CheckBox} name="incdelnote" checkedValue={1} label="削除データも表示" />
            </FieldSet>
            <FieldSet key={3}>
              <FieldItem>コメント種穎</FieldItem>
              <Field name="pubnotedivcd" component={DropDownPubNoteDivCd} addblank blankname="すべて" />
              <Field name="dispkbn" component={DropDown} items={sendmethodItems} addblank id="sendmethod" blankname="すべて" />
              {params.dispmode !== '2' && (
                <Field component={CheckBox} name="Chk" checkedValue={1} label="契約・団体コメントを表示する" />
              )}
              <Button onClick={handleSubmit((values) => onOpenCommentDetailGuide({ params, values }))} value="新規" />
              <Button onClick={this.handleOnSearchClick} value="検索" />
            </FieldSet>
          </FieldGroup>
        </form>
        <CommentDetailGuide rsvno={rsvno} perid={perid} orgcd1={orgcd1} orgcd2={orgcd2} ctrptcd={ctrptcd} />
      </div>
    );
  }
}

// propTypesの定義
CommentListHeader.propTypes = {
  consult: PropTypes.PropTypes.shape(),
  params: PropTypes.PropTypes.shape(),
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onOpenCommentDetailGuide: PropTypes.func,
  formValues: PropTypes.shape(),
  detailRefresh: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
};

CommentListHeader.defaultProps = {
  consult: null,
  params: null,
  onOpenCommentDetailGuide: null,
  formValues: null,
};

const CommentListHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: forName,
  enableReinitialize: true,
})(CommentListHeader);


const mapStateToProps = (state) => {
  const formValues = getFormValues(forName)(state);
  return {
    formValues,
    initialValues: {
      startdate: state.app.preference.pubNote.commentListFlameGuide.params.startdate,
      enddate: state.app.preference.pubNote.commentListFlameGuide.params.enddate,
      pubnotedivcd: state.app.preference.pubNote.commentListFlameGuide.params.pubnotedivcd,
      dispkbn: state.app.preference.pubNote.commentListFlameGuide.params.dispkbn,
      Chk: state.app.preference.pubNote.commentListFlameGuide.params.Chk,
      incdelnote: state.app.preference.pubNote.commentListFlameGuide.params.incdelnote,
    },
    consult: state.app.preference.pubNote.commentListFlameGuide.consult,
    params: state.app.preference.pubNote.commentListFlameGuide.params,
    detailRefresh: state.app.preference.pubNote.commentListFlameGuide.detailRefresh,
    message: state.app.preference.pubNote.commentListFlameGuide.message,
  };
};


// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSubmit: (params, formValues) => {
    const wkparams = { ...params };
    if (formValues.Chk !== undefined) {
      if (formValues.Chk === null) {
        wkparams.dispmode = '0';
      }
      if (formValues.Chk === 1) {
        wkparams.dispmode = '1';
      }
    }
    wkparams.pubnotedivcd = formValues.pubnotedivcd;
    wkparams.dispkbn = formValues.dispkbn;
    wkparams.incdelnote = formValues.incdelnote;
    wkparams.startdate = formValues.startdate;
    wkparams.enddate = formValues.enddate;
    if (formValues.startdate !== null) {
      wkparams.startdate = moment(formValues.startdate).format('YYYY/MM/DD');
    }
    if (formValues.enddate !== null) {
      wkparams.enddate = moment(formValues.enddate).format('YYYY/MM/DD');
    }
    dispatch(searchCommentListRequest({ params: wkparams }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CommentListHeaderForm));
