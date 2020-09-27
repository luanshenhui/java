import React from 'react';
import PropTypes from 'prop-types';
import { Field, getFormValues, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import moment from 'moment';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../../components/Field';
import GuideBase from '../../../components/common/GuideBase';
import GuideButton from '../../../components/GuideButton';
import MessageBanner from '../../../components/MessageBanner';
import Button from '../../../components/control/Button';
import Label from '../../../components/control/Label';
import Radio from '../../../components/control/Radio';
import DropDownPubNoteDivCd from '../../../components/control/dropdown/DropDownPubNoteDivCd';
import TextArea from '../../../components/control/TextArea';
import CheckBox from '../../../components/control/CheckBox';
import LabelOrgName from '../../../components/control/label/LabelOrgName';
import { closeCommentDetailGuide, registerPubNoteRequest, deletePubNoteRequest, setPubNoteDivState, changePubNoteDiv } from '../../../modules/preference/pubNoteModule';

const formName = 'CommentDetailForm';

// 表示対象フィールドの編集
const DispKbnField = ({ userdata, data }) => {
  // 表示対象フィールド設定
  const res = [];
  const { onlydispkbn } = data;

  // 表示対象区分しばりあり？ または権限が無い
  if (!(onlydispkbn === 1 || onlydispkbn === 2 || userdata.authnote === 0)) {
    res.push(<Field name="dispkbn" component={Radio} checkedValue={3} label="共通" key={1} />);
  }
  // 表示対象区分 事務のみ？ または権限が無い
  if (!(onlydispkbn === 2 || userdata.authnote === 0 || userdata.authnote === 2)) {
    res.push(<Field name="dispkbn" component={Radio} checkedValue={1} label="医療情報" key={2} />);
  }
  // 表示対象区分 医療のみ？ または権限が無い
  if (!(onlydispkbn === 1 || userdata.authnote === 0 || userdata.authnote === 1)) {
    res.push(<Field name="dispkbn" component={Radio} checkedValue={2} label="事務情報" key={3} />);
  }

  return res;
};

// 対象コメントフィールドの編集
const DispCommentField = ({ cmtmode }) => {
  // 対象コメントフィールド設定
  const res = [];
  let wkSentence = '';
  let selinfovalue = '';

  if (cmtmode) {
    const arrCmtmode = cmtmode.split(',');
    for (let i = 0; i < 4; i += 1) {
      if (arrCmtmode[i] === '1') {
        switch (i) {
          case 0:
            wkSentence = '今回の健診についてコメントを登録';
            break;
          case 1:
            wkSentence = 'この受診者に対してコメントを登録';
            break;
          case 2:
            wkSentence = 'この団体に対してコメントを登録';
            break;
          case 3:
            wkSentence = '今回の契約に対してコメントを登録';
            break;
          default:
            wkSentence = '';
            break;
        }
        selinfovalue = (i + 1).toString();
        res.push(<FieldValue key={wkSentence} ><Field name="selinfo" component={Radio} checkedValue={selinfovalue} label={wkSentence} /></FieldValue>);
      }
    }
  }

  return res;
};

class CommentDetailGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handlePubNoteDivChanged = this.handlePubNoteDivChanged.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // キャンセルボタンクリック時の処理
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }

  // 削除ボタンクリック時の処理
  handleRemoveClick(values) {
    const { onDelete } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('このコメントを削除してもよろしいですか。')) {
      return;
    }
    onDelete(values);
  }

  handlePubNoteDivChanged(event) {
    const { onPubNoteDivChanged, userdata, formValues } = this.props;
    const { target } = event;
    onPubNoteDivChanged({ params: { pubnotedivcd: target.value, authnote: userdata.authnote }, values: formValues });
  }

  // 保存ボタンクリック時の処理
  handleSubmit(values) {
    const { onSubmit } = this.props;
    onSubmit(values);
  }

  render() {
    const { handleSubmit, dispatch, onOpenColorGuide, message, rsvno, orgcd1, orgcd2, perid, consultdata, perdata, userdata, formValues } = this.props;
    const isUpdate = formValues && formValues.seq !== undefined && formValues.seq !== 0;
    const isDelete = (isUpdate && formValues && formValues.delflg === 1);
    return (
      <GuideBase {...this.props} title="コメント情報詳細" usePagination={false}>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div>
            <Button onClick={this.handleCancelClick} value="キャンセル" />
            <Button onClick={handleSubmit((values) => this.handleSubmit(values))} disabled={isDelete} value="保存" />
            {isUpdate && <Button onClick={handleSubmit((values) => this.handleRemoveClick(values))} value="削除" />}
          </div>
          {isDelete && (
            <Label><strong>このデータは削除されたデータです。修正できません。</strong></Label>
          )}
          <MessageBanner messages={message} />
          {rsvno && rsvno !== null && Number.parseInt(rsvno, 10) > 0 && (
            <FieldGroup itemWidth={120}>
              <FieldSet>
                <FieldItem>受診日</FieldItem>
                <Label>{consultdata.csldate !== undefined && moment(consultdata.csldate).format('YYYY/MM/DD')}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>コース</FieldItem>
                <Label>{consultdata.csname}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>当日ＩＤ</FieldItem>
                <Label>{consultdata.dayid}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>団体</FieldItem>
                <Label>{consultdata.orgname}</Label>
              </FieldSet>
            </FieldGroup>
          )}
          {(rsvno === undefined || rsvno === null || Number.parseInt(rsvno, 10) === 0) && (
            <FieldGroup itemWidth={120}>
              {(orgcd1 && orgcd1 !== '') && (orgcd2 && orgcd2 !== '') && (
                <FieldSet>
                  <FieldItem>団体</FieldItem>
                  <LabelOrgName orgcd1={orgcd1} orgcd2={orgcd2} />
                </FieldSet>
              )}
            </FieldGroup>
          )}
          {perid && perid !== '' && (
            <FieldGroup itemWidth={120}>
              <FieldSet>
                <FieldValueList>
                  <FieldValue>
                    <Label><strong>{perdata.lastname}　{perdata.firstname}</strong> （{perdata.lastkname}　{perdata.firstkname}）</Label>
                  </FieldValue>
                  <FieldValue>
                    <Label>　　{perdata.birth !== undefined &&
                      `${perdata.birthyearshorteraname}${perdata.birtherayear}${moment(perdata.birth).format('(YYYY).MM.DD')}生`}　{perdata.age !== null && (
                        `${Number.parseInt(perdata.age, 10)}歳`)}　{perdata.gender === '1' ? '男性' : '女性'}
                    </Label>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
            </FieldGroup>
          )}
          <FieldGroup itemWidth={120}>
            <FieldSet>
              <FieldItem>コメント種類</FieldItem>
              {userdata && userdata.authnote === 0 ?
                <Label>{formValues && formValues.pubnotedivname}</Label>
                :
                <Field name="pubnotedivcd" component={DropDownPubNoteDivCd} obtainPubNoteDiv={(pubnotediv) => dispatch(setPubNoteDivState(pubnotediv))} onChange={this.handlePubNoteDivChanged} />
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>表示対象</FieldItem>
              <DispKbnField userdata={userdata} data={formValues} />
            </FieldSet>
            <FieldSet>
              <FieldItem>コメント</FieldItem>
              <Field name="pubnote" component={TextArea} id="sendecomment" style={{ width: 390, height: 70 }} />
            </FieldSet>
            <FieldSet>
              <FieldItem>対象コメント</FieldItem>
              <FieldValueList>
                <DispCommentField cmtmode={formValues && formValues.cmtmode} />
              </FieldValueList>
            </FieldSet>
            <FieldSet>
              <FieldItem>表示色</FieldItem>
              <GuideButton onClick={onOpenColorGuide} />
              <Label>■</Label>
              <Field name="dispcolor" component="input" type="hidden" />
              <Field name="boldflg" component={CheckBox} checkedValue={1} label="このコメントは太字で表示する" />
            </FieldSet>
            <FieldSet>
              <FieldItem>更新日時</FieldItem>
              <Label>{formValues && formValues.upddate !== undefined && moment(formValues && formValues.upddate).format('YYYY/MM/DD HH:mm:ss')}</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>更新者</FieldItem>
              <Label>{formValues && formValues.username}</Label>
            </FieldSet>
          </FieldGroup>
        </form>
      </GuideBase>
    );
  }
}

const CommentDetailGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(CommentDetailGuide);

CommentDetailGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  dispatch: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  formValues: PropTypes.shape(),
  seq: PropTypes.number,
  rsvno: PropTypes.string,
  orgcd1: PropTypes.string,
  orgcd2: PropTypes.string,
  perid: PropTypes.string,
  ctrptcd: PropTypes.string,
  cmtmode: PropTypes.string,
  pubnotedivcd: PropTypes.string,
  consultdata: PropTypes.shape(),
  perdata: PropTypes.shape(),
  userdata: PropTypes.shape(),
  pubnotediv: PropTypes.arrayOf(PropTypes.shape()),
  data: PropTypes.shape(),
  onSubmit: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  onOpenColorGuide: PropTypes.func.isRequired,
  onPubNoteDivChanged: PropTypes.func.isRequired,
};

CommentDetailGuide.defaultProps = {
  seq: 0,
  rsvno: '0',
  pubnotedivcd: undefined,
  orgcd1: undefined,
  orgcd2: undefined,
  perid: undefined,
  ctrptcd: undefined,
  cmtmode: '',
  formValues: undefined,
  consultdata: {},
  perdata: {},
  userdata: {},
  data: {},
  pubnotediv: [],
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: state.app.preference.pubNote.commentDetailGuide.data,
    formValues,
    message: state.app.preference.pubNote.commentDetailGuide.message,
    visible: state.app.preference.pubNote.commentDetailGuide.visible,
    userdata: state.app.preference.pubNote.commentDetailGuide.userdata,
    consultdata: state.app.preference.pubNote.commentDetailGuide.consultdata,
    perdata: state.app.preference.pubNote.commentDetailGuide.perdata,
  };
};

const mapDispatchToProps = (dispatch, props) => ({
  onSubmit: (data) => {
    const { rsvno, orgcd1, orgcd2, perid, ctrptcd } = props;
    // 保存ボタン押下時
    dispatch(registerPubNoteRequest({ data: { ...data, rsvno, orgcd1, orgcd2, perid, ctrptcd } }));
  },
  onDelete: (data) => {
    const { rsvno, orgcd1, orgcd2, perid, ctrptcd } = props;
    // 削除ボタン押下時
    dispatch(deletePubNoteRequest({ selinfo: data.selinfo, seq: data.seq, rsvno, orgcd1, orgcd2, perid, ctrptcd }));
  },
  onOpenColorGuide: () => {},
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeCommentDetailGuide());
  },
  // クローズ時の処理
  onPubNoteDivChanged: ({ params, values }) => {
    // コメント分類選択時アクションを呼び出す
    dispatch(changePubNoteDiv({ params, values }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CommentDetailGuideForm);
