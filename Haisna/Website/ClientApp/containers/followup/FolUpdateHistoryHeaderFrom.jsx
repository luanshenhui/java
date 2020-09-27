import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';

import { getFollowLogListRequest } from '../../modules/followup/followModule';
import { openUserGuide, closeUserGuide } from '../../modules/preference/hainsUserModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import GuideButton from '../../components/GuideButton';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import Chip from '../../components/Chip';
import UserGuide from '../common/UserGuide';

const formName = 'FolUpdateHistoryHeader';

const searchUpdClass = [
  { value: 'X', name: 'すべて' },
  { value: '1', name: 'フォローアップ情報' },
  { value: '2', name: '二次検査結果' },
];
const orderbyItem = [
  { value: '0', name: '更新日' },
  { value: '1', name: '更新者' },
  { value: '2', name: '予約番号' },
];

const orderbyMode = [
  { value: '0', name: '昇順' },
  { value: '1', name: '降順' },
];

const limit = [
  { value: 50, name: '50行ずつ' },
  { value: 100, name: '100行ずつ' },
  { value: 200, name: '200行ずつ' },
  { value: 300, name: '300行ずつ' },
  { value: 9999, name: 'すべて' },
];

class FolUpdateHistoryHeader extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleUserNameClear = this.handleUserNameClear.bind(this);
  }

  // 検索ボタンを押下
  handleSubmit(values) {
    const { onSearch, rsvno } = this.props;
    onSearch({ ...values, page: 1, rsvno });
  }

  handleUserNameClear() {
    const { setValue } = this.props;
    setValue('searchUpdUser', null);
    setValue('userName', null);
  }

  render() {
    const { handleSubmit, onOpenGdeUserGuide, formValues } = this.props;
    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <div>
          <FieldGroup itemWidth={100}>
            <FieldSet>
              <FieldItem>更新日</FieldItem>
              <Field name="startUpdDate" component={DatePicker} id="startUpdDate" />
              <Label>～</Label>
              <Field name="endUpdDate" component={DatePicker} id="endUpdDate" />
            </FieldSet>
            <FieldSet>
              <FieldItem>分類</FieldItem>
              <Field name="searchUpdClass" component={DropDown} items={searchUpdClass} id="searchUpdClass" selectedValue="0" />
            </FieldSet>
            <FieldSet>
              <FieldItem> 更新ユーザ </FieldItem>
              <GuideButton onClick={() => {
                onOpenGdeUserGuide();
              }}
              />
              <UserGuide onSelectRow={this.handleSelectedUserGuide} />
              <span><Chip onDelete={this.handleUserNameClear} /></span>
              <Field name="searchUpdUser" component="input" type="hidden" />
              <Label>{formValues && formValues.userName}</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem> 表示 </FieldItem>
              <Field name="orderbyItem" component={DropDown} items={orderbyItem} id="orderbyItem" selectedValue="0" />の
              <Field name="orderbyMode" component={DropDown} items={orderbyMode} id="orderbyMode" selectedValue="0" />に
              <Field name="limit" component={DropDown} items={limit} id="limit" selectedValue="0" />
              <Button style={{ marginLeft: '10px' }} onClick={() => this.handleSubmit(formValues)} value="表示" />
            </FieldSet>
          </FieldGroup>
        </div>
      </form>
    );
  }
}

const FolUpdateHistoryHeaderFrom = reduxForm({
  form: formName,
})(FolUpdateHistoryHeader);

// propTypesの定義
FolUpdateHistoryHeader.propTypes = {
  formValues: PropTypes.shape(),
  setValue: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onOpenGdeUserGuide: PropTypes.func.isRequired,
  rsvno: PropTypes.number.isRequired,
};

FolUpdateHistoryHeader.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      startUpdDate: moment().format('YYYY/MM/DD'),
      endUpdDate: moment().format('YYYY/MM/DD'),
      searchUpdClass: 'X',
      searchUpdUser: '',
      orderbyItem: '0',
      orderbyMode: '0',
      limit: '50',
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    dispatch(getFollowLogListRequest({ conditions }));
  },

  onOpenGdeUserGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openUserGuide());
  },

  onCloseUserGuide: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeUserGuide());
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FolUpdateHistoryHeaderFrom);
