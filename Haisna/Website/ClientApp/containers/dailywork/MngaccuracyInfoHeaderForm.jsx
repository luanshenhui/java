import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../components/Field';
import DatePicker from '../../components/control/datepicker/DatePicker';
import MessageBanner from '../../components/MessageBanner';
import DropDown from '../../components/control/dropdown/DropDown';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';
import { getMngAccuracyRequest, initializeMngList } from '../../modules/dailywork/mngAccuracyModule';

const genderModeInfoItems = [{ value: 1, name: '男性のみ' }, { value: 2, name: '女性のみ' }, { value: 3, name: '男女個別で全て' }, { value: 4, name: '性別区別なし' }];

const formName = 'MngaccuracyInfoHeader';

const Wrapper = styled.span`
color: #999999;
`;

const WrapperButton = styled.div`
margin-bottom: 10px;
`;
class MngaccuracyInfoHeader extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // コンポーネントがアンマウントされる前に1回だけ呼ばれる処理
  componentWillUnmount() {
    // 一覧を初期化する
    const { initializeList } = this.props;
    initializeList();
  }

  // 検索実行
  handleSubmit(values) {
    const { onSubmit } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit(values);
  }

  render() {
    const { handleSubmit, message } = this.props;
    return (
      <div>
        <MessageBanner messages={message} />
        <form>
          <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="検索" /><WrapperButton />
          <FieldGroup itemWidth={80}>
            <FieldSet>
              <FieldItem>受診日</FieldItem>
              <Field name="strcsldate" component={DatePicker} id="strcsldate" />
            </FieldSet>
            <FieldSet>
              <FieldItem>表示対象</FieldItem>
              <Field name="gendermode" component={DropDown} items={genderModeInfoItems} id="gendermode" />
            </FieldSet>
            <FieldSet>
              <FieldItem>基準外</FieldItem>
              <FieldValueList>
                <FieldValue>
                  <Field name="border" component={TextBox} style={{ width: 50 }} id="border" maxLength="4" />
                  <Label>%以上の基準値外比率は強調して表示 </Label>
                </FieldValue>
                <FieldValue>
                  <Wrapper>※空白で実行した場合、強調表示はされません。</Wrapper>
                </FieldValue>
              </FieldValueList>
            </FieldSet>
          </FieldGroup>
        </form>
      </div>
    );
  }
}


const MngaccuracyInfoHeaderForm = reduxForm({
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,

})(MngaccuracyInfoHeader);

MngaccuracyInfoHeader.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSubmit: PropTypes.func.isRequired,
  initializeList: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  initialValues: state.app.dailywork.mngAccuracy.mngaccuracyInfoList.conditions,
  message: state.app.dailywork.mngAccuracy.mngaccuracyInfoList.message,
  // 可視状態
  conditions: state.app.dailywork.mngAccuracy.mngaccuracyInfoList.conditions,
});

const mapDispatchToProps = (dispatch) => ({
  onSubmit: (params) => {
    dispatch(getMngAccuracyRequest(params));
  },
  initializeList: () => {
    dispatch(initializeMngList());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MngaccuracyInfoHeaderForm);
