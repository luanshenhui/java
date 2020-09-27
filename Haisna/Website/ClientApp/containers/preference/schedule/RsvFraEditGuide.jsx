import React from 'react';
import PropTypes from 'prop-types';
import { Field, getFormValues, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import moment from 'moment';
import GuideBase from '../../../components/common/GuideBase';
import MessageBanner from '../../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import TextBox from '../../../components/control/TextBox';
import Button from '../../../components/control/Button';
import Label from '../../../components/control/Label';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import DropDownRsvGrp from '../../../components/control/dropdown/DropDownRsvGrp';
import DropDownCourseRsvGrp from '../../../components/control/dropdown/DropDownCourseRsvGrp';
import { insertRsvFraRequest, updateRsvFraRequest, deleteRsvFraRequest, closeRsvFraGuide } from '../../../modules/preference/scheduleModule';

const formName = 'RsvFraEdit';

class RsvFraEditGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  // 削除
  handleRemoveClick(rsvFraData) {
    const { onDelete, conditions } = this.props;

    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この予約枠情報を削除します。よろしいですか？')) {
      return;
    }
    onDelete(rsvFraData, conditions);
  }
  // 登録
  handleSubmit(values) {
    const { onSubmit, mode, conditions } = this.props;
    onSubmit(mode, values, conditions);
  }

  render() {
    const { message, handleSubmit, onClose, formValues, mode } = this.props;
    return (
      <GuideBase {...this.props} title="予約枠登録・修正" usePagination={false}>
        <form>
          <div>
            {mode === 'update' &&
              <Button onClick={() => this.handleRemoveClick({ cslDate: formValues.csldate, csCd: formValues.cscd, rsvGrpCd: formValues.rsvgrpcd })} value="削除" />
            }
            <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="確定" />
            <Button onClick={() => { onClose(); }} value="キャンセル" />
            <MessageBanner messages={message} />
          </div>
          <FieldGroup itemWidth={180}>
            <FieldSet>
              <FieldItem>受診日</FieldItem>
              {mode === 'update' ?
                <Label>{moment(formValues && formValues.csldate).format('YYYY 年 MM 月 DD 日')}</Label>
                : <Field name="csldate" component={DatePicker} id="csldate" />
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>コース</FieldItem>
              {mode === 'update' ?
                <Label>{formValues && formValues.csname}</Label>
                : <Field name="cscd" component={DropDownCourseRsvGrp} addblank id="cscd" />
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>予約群</FieldItem>
              {mode === 'update' ?
                <Label>{formValues && formValues.rsvgrpname}</Label>
                : <Field name="rsvgrpcd" component={DropDownRsvGrp} addblank id="rsvgrpcd" />
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>予約可能人数（共通）</FieldItem>
              {((formValues && formValues.mnggender === 0) || mode === 'insert') ?
                <Field name="maxcnt" component={TextBox} id="maxcnt" maxLength={10} size="10" style={{ width: 100 }} />
                : <Label>指定不可能</Label>
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>予約可能人数（男性）</FieldItem>
              {(formValues && formValues.mnggender === 0 && mode === 'update') ?
                <Label>指定不可能</Label>
                : <Field name="maxcnt_m" component={TextBox} maxLength={3} size="10" id="maxcnt_m" style={{ width: 100 }} />
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>予約可能人数（女性）</FieldItem>
              {(formValues && formValues.mnggender === 0 && mode === 'update') ?
                <Label>指定不可能</Label>
                : <Field name="maxcnt_f" component={TextBox} maxLength={3} size="10" id="maxcnt_f" style={{ width: 100 }} />
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>オーバ可能人数（共通）</FieldItem>
              {((formValues && formValues.mnggender === 0) || mode === 'insert') ?
                <Field name="overcnt" component={TextBox} id="overcnt" maxLength={3} size="10" style={{ width: 100 }} />
                : <Label>指定不可能</Label>
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>オーバ可能人数（男性）</FieldItem>
              {(formValues && formValues.mnggender === 0 && mode === 'update') ?
                <Label>指定不可能</Label>
                : <Field name="overcnt_m" component={TextBox} id="overcnt_m" maxLength={3} size="10" style={{ width: 100 }} />
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>オーバ可能人数（女性）</FieldItem>
              {(formValues && formValues.mnggender === 0 && mode === 'update') ?
                <Label>指定不可能</Label>
                : <Field name="overcnt_f" component={TextBox} id="overcnt_f" maxLength={3} size="10" style={{ width: 100 }} />
              }
            </FieldSet>
            <FieldSet>
              <FieldItem>予約済み人数（男）</FieldItem>
              <Label>{formValues && formValues.rsvcnt_m}人</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>予約済み人数（女）</FieldItem>
              <Label>{formValues && formValues.rsvcnt_f}人</Label>
            </FieldSet>
          </FieldGroup>
        </form>
      </GuideBase>
    );
  }
}

const RsvFraEditForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(RsvFraEditGuide);

RsvFraEditGuide.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  formValues: PropTypes.shape(),
  mode: PropTypes.string.isRequired,
  conditions: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

RsvFraEditGuide.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    // 団体登録フォームの初期値設定
    initialValues: state.app.preference.schedule.rsvFraEditGuide.rsvFraData,
    formValues,
    // 編集モード
    mode: state.app.preference.schedule.rsvFraEditGuide.mode,
    // 可視状態
    visible: state.app.preference.schedule.rsvFraEditGuide.visible,
    message: state.app.preference.schedule.rsvFraEditGuide.message,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onSubmit: (mode, rsvFraData, conditions) => {
    if (mode === 'insert') {
      dispatch(insertRsvFraRequest({ rsvFraData, conditions }));
    } else {
      dispatch(updateRsvFraRequest({ rsvFraData, conditions }));
    }
  },
  onDelete: (rsvFraData, conditions) => {
    dispatch(deleteRsvFraRequest({ rsvFraData, conditions }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeRsvFraGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RsvFraEditForm);
